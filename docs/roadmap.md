# ZeroSync Roadmap

This is a rough writeup of the project's roadmap. Nothing here is set in stone. Subgoals change frequently as we're still exploring the solution space. This document is probably not even up to date as you read it. However, it gives you an idea of where we're currently heading.


## Milestone 1: *"assumevalid"*

Implement a chain proof that mimics the ["assumevalid" option of Bitcoin Core](https://bitcoincore.org/en/2017/03/08/release-0.14.0/#assumed-valid-blocks). It parses the blocks and its transactions, validates the chain's work, its chain of hashes, and correctly manages the UTXO set. It also validates the coin supply, the transaction amounts, and fees. It verifies mostly everything except for the signatures. (More precisely: it verifies no witness data.)

- ✅ Parse headers, transactions, and blocks
- ✅ Verify the chain of hashes (block hash, previous block hash, Merkle root, TXIDs)
- ✅ Verify the work in the chain (proof-of-work, median time, and difficulty adjustment)
- ✅ Verify the UTXO set (Utreexo accumulator and a "bridge node" to provide the inclusion proofs)
- 👷‍♂️ Chain of proofs with recursive STARKs: Verify the previous chain proof in the current chain proof


## Milestone 2: *"measure and optimise"* 

Measure the performance of *assumevalid* proofs and optimise them until we can further extend them with the validation of Bitcoin Scripts.

- 👷‍♂️ Benchmark the *assumevalid proof* with blocks full of transactions (e.g. up to 3500 TXs)
	+ The largest block validated with the current Cairo program for now is [Block 383838](https://blockstream.info/block/00000000000000000e9b42248aa61593ccc4aa0a399b3cb6b50c650f45761c3a) which includes a total of 933 transactions. Generating the trace with [cairo-rs-py](https://github.com/lambdaclass/cairo-rs-py) took 50 minutes and 31 Million execution steps. 
	+ Benchmarks for different block sizes 	
		| Commit Hash | Block number | txs     | Steps        | Runner time | Prover time | Max RAM |
		| ----------- | ------------ | ------- | ------------ | ----------- | ----------- | ------- |
		| 1e614c1     | 100000       | 4       | 92,530       | 0:00:27     | 0:00:12     | 0.69 GB |
		| 1e614c1     | 170000       | 27      | 967,717      | 0:01:48     | 0:01:26     | 1.99 GB |
		| 1e614c1     | 328734       | 49      | 1,513,705    | 0:02:41     | 0:02:44     | 2.85 GB |
		| 1e614c1     | 222224       | 108     | 3,557,542    | 0:05:42     | 0:05:37     | 5.82 GB |
		|             | 383838       | 903     | 31,281,985   | 0:49:00     | 0:46:27     | 253.7GB |

- 👷‍♂️ Identify the performance bottlenecks and see if there are any showstoppers
- 👷‍♂️ Optimise the bottlenecks until we can start to add validation of Bitcoin Script


## Milestone 3: *"Bitcoin Script"*

Implement witness verification and complete the full chain proof. 

- Bitcoin Script
	- Compute signature hashes (ALL, NONE, SINGLE, ANYONECANPAY, ... )
	- Script interpreter (implement all opcodes)
- Payment types
	- Legacy: p2pk, p2pkh, p2sh
	- SegWit: p2wpkh, p2wsh
	- Taproot: p2tr; key path & script path spend
- 👷‍♂️ Crypto
	- Schnorr, ✓ ECDSA
	- ✓ SHA256, ✓ HASH256, ✓ SHA1, ✓ RIPEMD160, ✓ HASH160
- 👷‍♂️ Chain verifier
	- ✓ Demo the chain verifier in [a simple website](https://zerosync.org)
	- Client to download and prove a chainstate directory for a Bitcoin Core full node
	

After this milestone we can sync a pruned full node by downloading only the current UTXO set. Running a zerosync'd full node requires no modification of the code of Bitcoin Core. We just copy the UTXO set into Core's chainstate directory after verifying it. Ideally, we combine this with [AssumeUTXO](https://bitcoinops.org/en/topics/assumeutxo/) to gradually roll out ZeroSync while still having a backup check to verify the verification 🤓


## Milestone 4: *Hardening*
For the proof to become production ready we will have to test, review, and harden the code thoroughly.

- Gather Bitcoin developer feedback
- Perform code reviews
- More testing. Use the [static test vectors](https://raw.githubusercontent.com/bitcoin-core/qa-assets/main/unit_test_data/script_assets_test.json). Also add fuzzing
- Bug Bounty program


## Long-term Vision: *"zerosync and scan the chain efficiently"*

- Merkelized headers chain. Compact and flexible inclusion proofs for any transaction in the blockchain.
- *Block filters* for zk-clients to quickly check if a block is relevant to them.
- *Compact blocks* for zk-clients to download only the parts of blocks that are relevant to them. (E.g. for lightning nodes to scan the blockchain quickly they could use specific zk-blocks reduced to only the hash preimages revealed in unilateral channel closes)


### Further Ideas:
- Proof-of-reserves / compact ring signatures
	- E.g. Prove that you control outputs worth at least 1 BTC without revealing which ones. 
	- Or an anonymous voting amongst all Bitcoiners weighted by their stake.
- Instant history verification for client-side validation (CSV) protocols like Omni, RGB, or Taro. 
	- Better privacy with transaction graph obfuscation. Every TX could be a teleport between two unrelated UTXOs proven in zk.
	- A CSV protocol with a zk-VM, in theory capable of processing infinite amounts of data without bloating a token's history.
- Cross-chain bridges
- Enhance privacy of routing in the Lightning Network?
- Very long-term vision: Verify STARKs in Simplicity (Mid-term: verify STARKs in [Simplicity on Liquid soon?](https://www.youtube.com/watch?t=1185&v=i1g9fm6g5Cg)) 
	- STARK sidechains with trustless two-way pegs


# History of ZeroSync

- In February 2022 [Lukas George](https://github.com/lucidLuckylee) started [STARK relay](https://github.com/lucidLuckylee/LightSync), his bachelor thesis at TU Berlin, in which he proved the headers chain of Bitcoin.
- [Geometry Research](https://geometryresearch.xyz) offered a grant to fund the development.
- In July 2022 [Robin Linus](https://robinlinus.com) joined as lead developer and together they founded ZeroSync to grow the project into a full chain proof.
- [Ruben Somsen](https://medium.com/@RubenSomsen/snarks-and-the-future-of-blockchains-55b82012452b) gave the project its name ZeroSync. 
- In September 2022 [Max Gillett](https://github.com/maxgillett), who developed the Giza prover, joined the team to implement recursive proofs.
