# Roadmap

## Milestone 1: *zerosync instead of IBD*

- STARK recursion
	- STARK validator in Cairo (Who implements the validator?)
		- With a STARK-friendly hash function? (Use it in Giza prover, too)
	- What is our exact API for recursion? (program hash as public input?)
- UTXO accumulator
	- Generic API: append, prove, delete
	- Which accumulator?
		- (Merkle + bitfield, Utreexo, RSA accumulator, Verkle tree, STARK?, ...)
	- Inclusion proof provider (run a local "bridge node")
- Bitcoin Script
	- Compute signature hashes
	- Script interpreter
- Payment types
	- p2pk
	- p2pkh, p2psh
	- SegWit: p2wpkh, p2wsh
	- Taproot: p2tr; key path & script path spend
- Crypto
	- ECDSA, Schnorr
	- SHA256, HASH256, SHA1, RIPEMD160, HASH160 ...
- Chain verifier
	- Download and prove a chainstate directory for a Bitcoin Core full node
	- Demo for state proof in web browser?


## Milestone 2: *zerosync and scan the chain efficiently*

- Compact blocks (compressed for light clients)
- Block filters
- Merklized headers chain