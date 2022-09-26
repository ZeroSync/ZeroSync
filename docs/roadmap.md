# ZeroSync Roadmap

This is a rough writeup of the project's roadmap. Nothing here is set in stone. Subgoals change frequently as we're still exploring the solution space. This document is probably not even up to date as you read it. However, it gives you an idea of where we're currently heading.


## Milestone 1: *"assumevalid"*

Implement a chain proof that mimics the ["assumevalid" option of Bitcoin Core](https://bitcoincore.org/en/2017/03/08/release-0.14.0/#assumed-valid-blocks). It parses the blocks and its transactions, validates the chain's work, its chain of hashes, and correctly manages the UTXO set. It also validates coin creation, the transaction amounts, and fees. It verifies mostly everything except for the signatures. (More precisely: it verifies no witness data.)

- ✅ Parse blocks, headers, and transactions
- ✅ Verify the chain of hashes (block hash, previous block hash, Merkle root, TXIDs)
- 👷‍♂️ Verify the chain's work (proof-of-work and difficulty retargeting)
- ✅ Verify the UTXO set (Utreexo accumulator and a "bridge node" to provide the inclusion proofs)
- 👷‍♂️ Chain of proofs with recursive STARKs: Verify the previous chain proof in the current chain proof


## Milestone 2: *"measure and optimise"* 

Measure the performance of *assumevalid* proofs and optimise them until we can further extend them with the validation of Bitcoin Scripts.

- Benchmark the *assumevalid proof* with blocks full of transactions
- Identify the performance bottlenecks and see if there are any showstoppers
- Optimise the bottlenecks such until we can start to add Script validation


## Milestone 3: *"Bitcoin Script"*
Implement witness verification and complete the full chain proof. 

- Bitcoin Script
	- Compute signature hashes (ALL, NONE, SINGLE, ANYONECANPAY, ... )
	- Script interpreter (All opcodes)
- Payment types
	- Legacy: p2pk, p2pkh, p2sh
	- SegWit: p2wpkh, p2wsh
	- Taproot: p2tr; key path & script path spend
- Crypto
	- ECDSA, Schnorr
	- SHA256, HASH256, SHA1, RIPEMD160, HASH160, ...
- Chain verifier 
	- Software to download and prove a chainstate directory for a Bitcoin Core full node
	- Demo the chainstate proof in a simple website

After this milestone we can sync a pruned full node by downloading only the current UTXO set. Running a zerosync'd full node requires no modification of the code of Bitcoin Core. We just copy the UTXO set into Core's chainstate directory after verifying it.


## Long-term Vision: *"zerosync and scan the chain efficiently"*

- *Block filters* for zk-clients to quickly check if a block is relevant to them.
- *Compact blocks* for zk-clients to download only the parts of blocks that are relevant to them.
- Merkelized headers chain. Compact and flexible inclusion proofs for any transaction in the blockchain.

### Further Ideas:
- Compact ring signatures: E.g. Prove that you control outputs worth at least 1 BTC without revealing which ones.
- Instant history verification for client-side validation protocols like Omni, RGB, or Taro.
	- Better privacy with transaction graph obfuscation. Every TX could be a coin teleport proven in zk.
- Enhance privacy of routing in the Lightning Network?



# History of ZeroSync

- In February 2022 [Lukas George](https://github.com/lucidLuckylee) started [STARK relay](https://github.com/lucidLuckylee/zerosync/tree/relay), his bachelor thesis at TU Berlin, in which he proved the headers chain of Bitcoin.
- In July 2022 [Robin Linus](https://github.com/robinlinus) joined the project to grow it into a full chain proof. 
- [Geometry Research](https://geometryresearch.xyz) offered a grant to fund the development.
- [Ruben Somsen](https://medium.com/@RubenSomsen/snarks-and-the-future-of-blockchains-55b82012452b) gave the project its name ZeroSync. 

