# ZeroSync

**Don't trust. Verify.** ZeroSync allows to verify Bitcoin's chain state in an instant. No need to download hundreds of gigabytes of blocks. A tiny cryptographic proof suffices to validate the entire history of transactions and everyone's current balances.


Furthermore, ZeroSync aims to become a tool box for custom Bitcoin proofs. STARK proofs enable you to transform the blockchain data, enhance it, filter it, index it for efficient queries, and optimise it for your individual use case.

This is an early stage project. Expect frequent breaking changes. [Here is the project roadmap](roadmap.md).

WARNING: THIS CODE IS STILL FULL OF CRITICAL SECURITY BUGS!

## Requirements
- Python 3.7
- Cairo [Installation Guide](https://www.cairo-lang.org/docs/quickstart.html) (Programming language for provable programs)
- [Protostar](https://docs.swmansion.com/protostar/docs/tutorials/installation) (Automated testing)
- [Giza](https://github.com/maxgillett/giza) (Required for prover. Not necessary for development and testing)


## Run the Utreexo Bridge Node
The Utreexo bridge node is required to pass the tests for block verification. It provides the inclusion proofs for the coins spent in a block.

```sh
source ~/cairo_venv/bin/activate
python src/utreexo/bridge_node.py
```


## Run all Tests
```sh
protostar test --cairo-path=./src target src
```



## Run the Chain Prover
```sh
source ~/cairo_venv/bin/activate
```

```sh
python src/chain_proof/main.py
```

```sh
giza prove --trace=tmp/trace.bin --memory=tmp/memory.bin --program=tmp/program.json --output=tmp/proof.bin --num-outputs=50
```

## List TODOs in Code
```sh
 ./docs/todos
```


