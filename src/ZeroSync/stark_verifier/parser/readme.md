# Proof Parser

This is a library to write Rust objects into a Cairo memory such that we can then simply cast it into a high-level Cairo object. In particular, this implements parsing of STARKs for proof recursion.


## Example Usage 

```
cargo +nightly run -- src/proof.bin
```