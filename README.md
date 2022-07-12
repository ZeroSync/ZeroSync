# starkRelay

StarkRelay is a Relay that submits the latest block header in a batch of Bitcoin block headers to an Ethereum Smart Contract. The block headers are validated off-chain and the validation process includes calculating the block hash, checking the block's minimum time stamp as explained in the [wiki](https://en.bitcoin.it/wiki/Block_timestamp) and the correct target. In case a batch exceeds an epoch the target is recalculated for the first block of the next epoch using its previous block and the first block of the current epoch. All of this is implemented in Cairo, so its possible to create a verifiable STARK-proof attesting the correctness of the validation process. 

The submitted batches and their proofs are only verified on-chain and the last block of the batch is stored.

To enable SPV for every Bitcoin block one can submit intermediary headers of an already submitted batch.
Note that every epoch's first block has to be submitted publicly, meaning it has to be the last block of a submitted batch. You can, however, skip an entire epoch if your proof creation capabilities allow for it. Keep in mind that I was not able to test this yet.

**In general all of this is experimental research code and not to be used in production!**

## Requirements

- Python3.7
- [Cairo v0.8.2.1](https://github.com/starkware-libs/cairo-lang/releases/tag/v0.8.2.1) - [installation guide](https://www.cairo-lang.org/docs/quickstart.html)
- Bitcoin client, e.g. [bitcoincore](https://bitcoincore.org/en/download/)
- If you want to create STARK-proofs without SHARP you need [giza](https://github.com/maxgillett/giza) (Keep the Cairo [license](https://github.com/starkware-libs/cairo-lang/blob/master/LICENSE.txt) in mind)

## Installation

- clone this repository and cd into it
- ` pip3 install -r python-requirements`
- starkRelay will prompt you for setup info when you first run it

## Usage

- Valdiate a batch:

```
starkRelay validate-batch [START]-[END] -s
```

- Proof inclusion of an intermediary header at position `X` in a batch:

```
starkRelay [X] [START]-[END] -s
```

You currently have to deploy the contract on your own and send the output of the off-chain program with a transaction. I will work on providing commands to automate that in the near future.


## Credits

sha256 code adopted from Lior Goldberg: https://github.com/starkware-libs/cairo-examples/tree/master/sha256

zkRelay by Martin Westerkamp: https://github.com/informartin/zkRelay/

## Old Repository
The initial repository contains benchmarks, which I will revisit before adding them here. If you are interested in them anyway, you can get some inspiration (and even a few results) here:
https://git.tu-berlin.de/luckylee/starkrelay
