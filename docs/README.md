<div align="center">
  <h1>ZeroSync</h1>
  <br />
  <a href="#about"><strong>A STARK proof to sync a Bitcoin full node in an instant »</strong></a>
  <br />
  <br />
  <a href="https://github.com/ZeroSync/ZeroSync/issues/new?assignees=&labels=bug&template=01_BUG_REPORT.md&title=bug%3A+">Report a Bug</a>
  ·
  <a href="https://github.com/ZeroSync/ZeroSync/issues/new?assignees=&labels=enhancement&template=02_FEATURE_REQUEST.md&title=feat%3A+">Request a Feature</a>
  .<a href="https://github.com/ZeroSync/ZeroSync/discussions">Ask a Question</a>
</div>

<details open="open">
<summary>Table of Contents</summary>

- [About](#about)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
- [Roadmap](#roadmap)
- [Support](#support)
- [Project assistance](#project-assistance)
- [Contributing](#contributing)
- [Authors & contributors](#authors--contributors)
- [Security](#security)
- [License](#license)
- [Acknowledgements](#acknowledgements)

</details>

## About

**Don't trust. Verify.** ZeroSync allows to verify Bitcoin's chain state in an instant. No need to download hundreds of gigabytes of blocks. A compact cryptographic proof suffices to validate the entire history of transactions and everyone's current balances.

Our first application is to zerosync Bitcoin Core in pruned mode. The long-term vision for ZeroSync is to become a tool box for custom Bitcoin proofs. STARK proofs enable you to transform the blockchain data, enhance it, filter it, index it for efficient queries, and optimise it for your individual use case.

This is an early stage project. Expect frequent breaking changes. [Here is the project roadmap](roadmap.md).

WARNING: THIS CODE IS STILL FULL OF CRITICAL SECURITY BUGS!

## Getting Started

## Prerequisites

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

## Run all Tests

```sh
protostar test --cairo-path=./src target src
```

## Run the Chain Prover

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

## Support

Reach out to the maintainer at one of the following places:

- [GitHub Discussions](https://github.com/ZeroSync/ZeroSync/discussions)
- Contact options listed on [this GitHub profile](https://github.com/abdelhamidbakhta)

## Project assistance

If you want to say **thank you** or/and support active development of Beerus:

- Add a [GitHub Star](https://github.com/ZeroSync/ZeroSync) to the project.
- Tweet about the Beerus.
- Write interesting articles about the project on [Dev.to](https://dev.to/), [Medium](https://medium.com/) or your personal blog.

Together, we can make ZeroSync **better**!

## Contributing

First off, thanks for taking the time to contribute! Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make will benefit everybody else and are **greatly appreciated**.

Please read [our contribution guidelines](CONTRIBUTING.md), and thank you for being involved!

## Authors & contributors

For a full list of all authors and contributors, see [the contributors page](https://github.com/ZeroSync/ZeroSync/contributors).

## Security

ZeroSync follows good practices of security, but 100% security cannot be assured.
ZeroSync is provided **"as is"** without any **warranty**. Use at your own risk.

_For more information and to report security issues, please refer to our [security documentation](SECURITY.md)._

## License

This project is licensed under the **MIT license**.

See [LICENSE](../LICENSE) for more information.

## Acknowledgements
