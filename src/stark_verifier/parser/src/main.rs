use winterfell::StarkProof;
use std::fs::File;
use std::io::{ BufReader, Read, Result };
use serde::{ Deserialize, Serialize };

use winter_air::proof::Context;
use std::env;


fn main() -> Result<()> {
    let args: Vec<String> = env::args().collect();
    // let address = (&args[1]).parse::<u64>().unwrap();

    let file = File::open("/Users/robinlinus/projects/zerosync/src/stark_verifier/parser/src/proof_9.bin")?;
    let mut buf_reader = BufReader::new(file);
    
    let mut data = Vec::new();
    buf_reader.read_to_end(&mut data).expect("Unable to read data");
    
    let data: ProofData = bincode::deserialize( &data ).unwrap();
    let proof = StarkProof::from_bytes(&data.proof_bytes).unwrap();


    let mut writer = FeltWriter::new();

    let proof_ptr = proof.write_into(&mut writer);

    writer.write_pointer(proof_ptr);
    
    let json_arr = serde_json::to_string(&writer.memory)?;
    println!( "{}", json_arr );

    Ok(())
}


#[derive(Serialize, Deserialize)]
struct ProofData {
    input_bytes: Vec<u8>,
    proof_bytes: Vec<u8>,
}


struct FeltWriter {
    pub memory: Vec<String>
}

impl FeltWriter {

    fn new() -> FeltWriter {
        FeltWriter {
            memory: Vec::new()
        }
    }

    fn write_pointer(&mut self, value: u64) -> u64 {
        self.memory.push(format!("{}", value ));
        self.head() - 1
    }


    fn write_u64(&mut self, value: u64) -> u64 {
        self.memory.push(format!("{:#X}", value ));
        self.head() - 1
    }

    fn write_array<T: Writeable + Sized>(&mut self, array: Vec<T>) -> u64 {
        // for each element
            // Write its children into the memory but the element into a temporary memory
        let mut temp_writer = FeltWriter::new();
        for element in array{
            element.write_into_temp(self, &mut temp_writer);
        }

        let array_ptr = self.head();

        // Copy the temporary memory into the memory
        self.memory.extend( temp_writer.memory );
        
        array_ptr
    }

    fn head(&self) -> u64 {
        self.memory.len() as u64
    }
}

trait Writeable{
    fn write_into(&self, target: &mut FeltWriter) -> u64;

    fn write_into_temp(&self, target: &mut FeltWriter, temp_target: &mut FeltWriter) -> u64;
}

impl Writeable for u8 {
    fn write_into(&self, target: &mut FeltWriter) -> u64{
        target.write_u64(*self as u64)
    }

    fn write_into_temp(&self, target: &mut FeltWriter, temp_target: &mut FeltWriter) -> u64{
        temp_target.write_u64(*self as u64)
    }
}

impl Writeable for StarkProof {
    fn write_into(&self, target: &mut FeltWriter) -> u64 {
        // Write children
        let proof_ptr = self.context.write_into(target);
        
        // Write self
        target.write_u64(self.pow_nonce as u64);

        proof_ptr
    }

    fn write_into_temp(&self, target: &mut FeltWriter, temp_target: &mut FeltWriter) -> u64 {
        unimplemented!();
    }
}


impl Writeable for Context {

    fn write_into(&self, target: &mut FeltWriter) -> u64 { 
        // Write children
        let trace_meta_ptr = target.write_array(self.get_trace_info().meta().to_vec());
        let field_modulus_bytes_ptr = target.write_array(self.field_modulus_bytes().to_vec());

        // Write self
        let context_ptr = target.head();
        target.write_u64( self.trace_length() as u64 ); // Do not serialize as a power of two
        target.write_u64( self.get_trace_info().meta().len() as u64 );
        target.write_pointer(trace_meta_ptr);
        target.write_u64( self.field_modulus_bytes().len() as u64 );
        target.write_pointer(field_modulus_bytes_ptr);

        context_ptr
    }

    fn write_into_temp(&self, target: &mut FeltWriter, temp_target: &mut FeltWriter) -> u64{
        unimplemented!();
    }
}
