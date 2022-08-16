# Bitcoin Hash Proofs

TODO: A library to prove all hash functions used in [Bitcoin (Script)](https://en.bitcoin.it/wiki/Script#Crypto)

- OP_RIPEMD160: The input is hashed using RIPEMD-160.
- OP_SHA1: The input is hashed using SHA-1.
- OP_SHA256: The input is hashed using SHA-256.
- OP_HASH160: The input is hashed twice: first with SHA-256 and then with RIPEMD-160.
- OP_HASH256: The input is hashed two times with SHA-256.
