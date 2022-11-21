mod tests {
    use serde::{Deserialize, Serialize};
    use std::fs::File;
    use std::io::{BufReader, Read};

    use winter_air::DefaultEvaluationFrame;
    use winter_crypto::{hashers::Blake2s_256, Digest, Hasher, RandomCoin};
    use winter_utils::{Deserializable, Serializable, SliceReader};
    use winterfell::{Air, AuxTraceRandElements, StarkProof, VerifierChannel, VerifierError};

    use giza_air::{ProcessorAir, PublicInputs};
    use giza_core::Felt;

    use blake2::blake2s::blake2s;

    // TODO: Use workspace so we can share code with parser package, and not duplicate here.
    // We can also convert these tests to exported Python-callable functions, that return
    // "ground truth" values for use in Protostar tests.
    #[derive(Serialize, Deserialize)]
    struct BinaryProofData {
        input_bytes: Vec<u8>,
        proof_bytes: Vec<u8>,
    }

    impl BinaryProofData {
        fn from_file(file_path: &String) -> BinaryProofData {
            let file = File::open(file_path).unwrap();
            let mut data = Vec::new();
            BufReader::new(file)
                .read_to_end(&mut data)
                .expect("Unable to read data");
            bincode::deserialize(&data).unwrap()
        }
    }

    #[test]
    fn draw_felt() -> Result<(), VerifierError> {
        let public_coin_seed = vec![0u8; 32];
        let mut public_coin = RandomCoin::<Felt, Blake2s_256<Felt>>::new(&public_coin_seed);
        //let seed = Blake2s_256::<Felt>::hash(&public_coin_seed);
        //let digest = Blake2s_256::<Felt>::merge_with_int(seed, 1);
        //println!("merge_with_int digest: {:02X?}\n", digest);
        let z = public_coin
            .draw::<Felt>()
            .map_err(|_| VerifierError::RandomCoinError)?;
        println!("draw_felt: {}\n", z.to_raw());

        Ok(())
    }

    #[test]
    fn merge_with_int() {
        let value = 1u64;
        let mut data = [0; 40];
        // the first 32 bytes are zeros
        // the 8 remaining bytes are the 64 bits of the value
        data[32..].copy_from_slice(&value.to_le_bytes());
        let digest: [u8; 32] = blake2s(32, &[], &data)
            .as_bytes()
            .try_into()
            .expect("slice with incorrect length");
        println!("merge_with_int digest: {:02X?}\n", digest);
    }

    #[test]
    fn draw_integers() {
        // TODO
    }

    #[test]
    fn draw_ood_point_z() -> Result<(), VerifierError> {
        let path = String::from("tests/stark_proofs/fibonacci.bin");

        let data = BinaryProofData::from_file(&path);
        let proof = StarkProof::from_bytes(&data.proof_bytes).unwrap();
        let pub_inputs =
            PublicInputs::read_from(&mut SliceReader::new(&data.input_bytes[..])).unwrap();

        let mut public_coin_seed = Vec::new();
        pub_inputs.write_into(&mut public_coin_seed);

        let air = ProcessorAir::new(proof.get_trace_info(), pub_inputs, proof.options().clone());

        let mut public_coin = RandomCoin::<Felt, Blake2s_256<Felt>>::new(&public_coin_seed);
        let channel = VerifierChannel::<
            Felt,
            Blake2s_256<Felt>,
            DefaultEvaluationFrame<Felt>,
            DefaultEvaluationFrame<Felt>,
        >::new(&air, proof)?;

        let trace_commitments = channel.read_trace_commitments();

        // reseed the coin with the commitment to the main trace segment
        public_coin.reseed(trace_commitments[0]);

        // process auxiliary trace segments (if any), to build a set of random elements for each segment
        let mut aux_trace_rand_elements = AuxTraceRandElements::<Felt>::new();
        for (i, commitment) in trace_commitments.iter().skip(1).enumerate() {
            let rand_elements = air
                .get_aux_trace_segment_random_elements(i, &mut public_coin)
                .map_err(|_| VerifierError::RandomCoinError)?;
            aux_trace_rand_elements.add_segment_elements(rand_elements);
            public_coin.reseed(*commitment);
        }

        // build random coefficients for the composition polynomial
        let _constraint_coeffs = air
            .get_constraint_composition_coefficients::<Felt, Blake2s_256<Felt>>(&mut public_coin)
            .map_err(|_| VerifierError::RandomCoinError)?;

        // 2 ----- constraint commitment --------------------------------------------------------------
        // read the commitment to evaluations of the constraint composition polynomial over the LDE
        // domain sent by the prover, use it to update the public coin, and draw an out-of-domain point
        // z from the coin; in the interactive version of the protocol, the verifier sends this point z
        // to the prover, and the prover evaluates trace and constraint composition polynomials at z,
        // and sends the results back to the verifier.
        let constraint_commitment = channel.read_constraint_commitment();
        public_coin.reseed(constraint_commitment);
        let z = public_coin
            .draw::<Felt>()
            .map_err(|_| VerifierError::RandomCoinError)?;

        println!("draw_ood_point_z: {}", z.to_raw());

        Ok(())
    }
}
