<div align="center">
  <h1>ZeroSync</h1>
  <br />
  <a href="#about"><strong>«A STARK proof to sync a Bitcoin full node in an instant»</strong></a>
  <br />
  <br />
  <a href="https://github.com/ZeroSync/ZeroSync/issues/new?assignees=&labels=bug&template=01_BUG_REPORT.md&title=bug%3A+">Report a Bug</a>
  |
  <a href="https://github.com/ZeroSync/ZeroSync/issues/new?assignees=&labels=enhancement&template=02_FEATURE_REQUEST.md&title=feat%3A+">Request a Feature</a>
  | <a href="https://github.com/ZeroSync/ZeroSync/discussions">Ask a Question</a>
</div>

<div align="center">
<br />

![GitHub Workflow Status](https://github.com/ZeroSync/ZeroSync/actions/workflows/CI.yml/badge.svg)
[![Project license](https://img.shields.io/github/license/ZeroSync/ZeroSync.svg)](../LICENSE)
[![Pull Requests welcome](https://img.shields.io/badge/PRs-welcome-ff69b4.svg?)](https://github.com/ZeroSync/ZeroSync/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22)
![GitHub Repo stars](https://img.shields.io/github/stars/ZeroSync/ZeroSync?style=social)
[![Twitter Follow](https://img.shields.io/twitter/follow/ZeroSync_?style=social)](https://twitter.com/ZeroSync_)

</div>


**Don't trust. Verify.** ZeroSync allows to verify Bitcoin's chain state in an instant. No need to download hundreds of gigabytes of blocks. A compact cryptographic proof suffices to validate the entire history of transactions and everyone's current balances. 

Our first application is to zerosync Bitcoin Core in pruned mode. The long-term vision for ZeroSync is to become a tool box for custom Bitcoin proofs. STARK proofs enable you to transform the blockchain data, enhance it, filter it, index it for efficient queries, and optimise it for your individual use case.

This is an early stage project. Expect frequent breaking changes. [Here is the project roadmap](roadmap.md).

WARNING: THIS CODE IS STILL FULL OF CRITICAL SECURITY BUGS!

## Requirements
- Python 3.9
- Cairo. [Installation Guide](https://www.cairo-lang.org/docs/quickstart.html) (Programming language for provable programs)
- [Protostar](https://docs.swmansion.com/protostar/docs/tutorials/installation) (Automated testing)
- [Giza](https://github.com/maxgillett/giza) (Required for prover. Not necessary for development and testing)


## Run the Utreexo Bridge Node
The Utreexo bridge node is required to pass the tests for block verification. It provides the inclusion proofs for the coins spent in a block.

```sh
source ~/cairo_venv/bin/activate
python src/utreexo/bridge_node.py
```


## Run all Unit Tests
```sh
protostar test --cairo-path=./src target src
```

## Build Parser
```sh
cd src/stark_verifier/parser/
cargo +nightly build

cd ../../..
```

## Run all Integration Tests
```sh
protostar test --cairo-path=./src tests
```

Run some tests with the Rust verifier to derive a detailed ground truth:

```sh
cargo +nightly test -- --show-output
```


## Run the Chain Prover

Note that you have to build the parser first, as described above.
```sh
source ~/cairo_venv/bin/activate
python3 src/chain_proof/main.py
```


## List TODOs
```sh
 ./docs/todos
```


## Roadmap

The roadmap is available [here](roadmap.md).
