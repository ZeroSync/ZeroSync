//SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

abstract contract IFactRegistry {
    /*
      Returns true if the given fact was previously registered in the contract.
    */
    function isValid(bytes32 fact) external view virtual returns (bool);
}

// adopted from https://github.com/informartin/zkRelay/blob/master/batch_verifier.sol

contract starkRelay {
    // needs to change when validate_compiled.json changes -> get new hash with cairo-hash-program --program validate_compiled.json
    //bytes32 cairoProgramHash_ =
    //      0x524d8ef8ad92b523a1deee0a8a10de38a73f29bea5ba3c6edc6296e444fe3a3;
    //bytes32 merkleProgramHash_ =
    //      0x216538184a8df2f293e82ef5237d4bc5c25b1572dcf4c506cffbc2ebf6e5ace;
    //cairo verifier: 0xAB43bA48c9edF4C2C4bB01237348D1D7B28ef168
    //current deployed contract on goerli:

    uint256 constant EPOCH_SIZE = 2016;

    //saved in LITTLE ENDIAN
    struct Block {
        uint32 version;
        uint256 prev_block;
        uint256 merkle_root;
        uint32 timeStamp;
        uint32 bits;
        uint32 nonce;
    }

    struct Batch {
        uint256 batchSize;
        uint256 headerHash;
        Block blockHeader;
        uint256 cumDifficulty;
        uint256 target;
        uint256 merkleRoot;
        mapping(uint256 => Block) intermediaryHeader;
    }

    struct Branch {
        uint256 startingAtBatchHeight;
        uint256 length;
        uint256 numBatchChain;
        Block firstBlockInEpoch;
        mapping(uint256 => Batch) batchChain;
    }

    uint256 numBranches;
    mapping(uint256 => Branch) branches;

    uint256 cairoProgramHash_;
    uint256 merkleProgramHash_;
    IFactRegistry cairoVerifier_;

    constructor(
        uint256 cairoProgramHash,
        uint256 merkleProgramHash,
        address cairoVerifier
    ) {
        cairoProgramHash_ = cairoProgramHash;
        merkleProgramHash_ = merkleProgramHash;
        cairoVerifier_ = IFactRegistry(cairoVerifier);
        Branch storage mainChain = branches[numBranches++];
        Batch storage batch = mainChain.batchChain[mainChain.numBatchChain++];
        //every block is saved in LITTLE ENDIAN -> so also block 0
        batch
            .headerHash = 0x6fe28c0ab6f1b372c1a6a246ae63f74f931e8365e15a089c68d6190000000000;
        batch.blockHeader = Block(
            0x01000000,
            0x0,
            0x3ba3edfd7a7b12b27ac72c3e67768f617fc81bc3888a51323a9fb8aa4b1e5e4a,
            0x29ab5f49,
            0xffff001d,
            0x1dac2b7c
        );
        mainChain.firstBlockInEpoch = batch.blockHeader;
        batch.batchSize = 1;
        mainChain.length = 0;
    }

    function blocksEqual(Block memory a, Block memory b)
        private
        pure
        returns (bool)
    {
        return (a.version == b.version &&
            a.prev_block == b.prev_block &&
            a.merkle_root == b.merkle_root &&
            a.timeStamp == b.timeStamp &&
            a.bits == b.bits &&
            a.nonce == b.nonce);
    }

    //blockIn should be an array of size 20 with each cell being 4 bytes of the bitcoin block
    function parseBlock(uint256[] memory raw, uint256 startIndex)
        private
        pure
        returns (Block memory)
    {
        uint256 tmpPrev = raw[startIndex + 1] *
            2**224 +
            raw[startIndex + 2] *
            2**192 +
            raw[startIndex + 3] *
            2**160 +
            raw[startIndex + 4] *
            2**128 +
            raw[startIndex + 5] *
            2**96 +
            raw[startIndex + 6] *
            2**64 +
            raw[startIndex + 7] *
            2**32 +
            raw[startIndex + 8];
        uint256 tmpMerkle = raw[startIndex + 9] *
            2**224 +
            raw[startIndex + 10] *
            2**192 +
            raw[startIndex + 11] *
            2**160 +
            raw[startIndex + 12] *
            2**128 +
            raw[startIndex + 13] *
            2**96 +
            raw[startIndex + 14] *
            2**64 +
            raw[startIndex + 15] *
            2**32 +
            raw[startIndex + 16];
        Block memory tmpBlock = Block(
            uint32(raw[startIndex + 0]),
            tmpPrev,
            tmpMerkle,
            uint32(raw[startIndex + 17]),
            uint32(raw[startIndex + 18]),
            uint32(raw[startIndex + 19])
        );
        return tmpBlock;
    }

    /*
        input: 
            0 -> batch size
            1 - 20 -> first block of the epoch
            21 - 40 -> first block of the batch     ---> used to compare firstBlock.prevhash to the prev batch last block hash
            41 -> variable indicating target recalculation position inside the given batch
            42 - 61 -> last block of the batch      ---> will be saved and is available in the contract
            62 - 63 -> hash of the last block of the batch (as two uint128 in little endian)     ---> used to build next batch upon
            64 -> target
            65 -> merkle root
    */

    function submitBatch(uint256[] memory programOutput) public {
        bytes32 outputHash = keccak256(abi.encodePacked(programOutput));
        bytes32 fact = keccak256(
            abi.encodePacked(cairoProgramHash_, outputHash)
        );
        require(cairoVerifier_.isValid(fact), "MISSING_CAIRO_PROOF");

        uint256 batchSize = programOutput[0];
        Block memory epochFirstBl = parseBlock(programOutput, 1);
        Block memory batchFirstBl = parseBlock(programOutput, 21);
        Block memory batchLastBl = parseBlock(programOutput, 42); //42 instead of 41 because target recalculation variable is in line 41
        uint256 batchLastHash = programOutput[62] * 2**128 + programOutput[63];

        // batches need to depend on (for now) latest verified block --> batch first block->prev block is the (in contract saved) latest block hash
        require(
            batchFirstBl.prev_block ==
                branches[0]
                    .batchChain[branches[0].numBatchChain - 1]
                    .headerHash,
            "Prev block hash is not correct"
        );
        require(verifyBatch(batchSize, epochFirstBl, programOutput[41], 0));

        Branch storage mainChain = branches[0];
        Batch storage batch = mainChain.batchChain[mainChain.numBatchChain];

        uint256[] memory tmp = new uint256[](5);
        tmp[0] = batchSize;
        tmp[1] = batchLastHash;
        tmp[2] = programOutput[64];
        tmp[3] = programOutput[65];
        tmp[4] = programOutput[41];
        createBatch(batchLastBl, mainChain, batch, tmp);
    }

    function verifyBatch(
        uint256 batchSize,
        Block memory epochFirstBl,
        uint256 targetVariable,
        uint256 branchId
    ) private view returns (bool) {
        //check if first epoch block is correct
        require(
            blocksEqual(branches[branchId].firstBlockInEpoch, epochFirstBl),
            "First epoch block is not correct"
        );

        // force first block of each epoch to be submitted if batch leads to a new epoch
        if (
            (batchSize + branches[branchId].length) / EPOCH_SIZE >
            branches[branchId].length / EPOCH_SIZE //true if the batch spans over two epochs/adds the first block of the next epoch
        ) {
            require(
                (batchSize + branches[branchId].length) % EPOCH_SIZE == 0, //batch ends with the next first epoch block
                "Batch advances an epoch, but the next epoch's first block was not the last block of the batch"
            );
        }

        // if a target recalculation happened it had to be at the correct block
        if (
            targetVariable !=
            0x0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF //reserved value for: no target recalculation happened
        ) {
            require(
                (targetVariable + 1 + branches[branchId].length) % EPOCH_SIZE ==
                    0,
                "Target recalculated at wrong block in batch"
            );
        } else {
            require(
                (batchSize + branches[branchId].length) / EPOCH_SIZE ==
                    branches[branchId].length / EPOCH_SIZE,
                "Missing target recalculation"
            );
        }
        return true;
    }

    //batchHeight - 1 is the batchNo (of the mainChain) this challenge builds on
    function createMainChainChallenge(
        uint256[] memory programOutput,
        uint256 batchHeight
    ) public returns (uint256 challengeId) {
        bytes32 outputHash = keccak256(abi.encodePacked(programOutput));
        bytes32 fact = keccak256(
            abi.encodePacked(cairoProgramHash_, outputHash)
        );
        require(cairoVerifier_.isValid(fact), "MISSING_CAIRO_PROOF");

        uint256 batchSize = programOutput[0];
        Block memory epochFirstBl = parseBlock(programOutput, 1);
        Block memory batchFirstBl = parseBlock(programOutput, 21);
        Block memory batchLastBl = parseBlock(programOutput, 42); //42 instead of 41 because target recalculation variable is in line 41
        uint256 batchLastHash = programOutput[62] * 2**128 + programOutput[63];

        require(
            branches[0].batchChain[batchHeight - 1].headerHash ==
                batchFirstBl.prev_block,
            "The submitted previous block hash is not the same as the block at the batchHeight on the main chain."
        );
        // batches need to depend on (for now) latest verified block --> batch first block->prev block is the (in contract saved) latest block hash

        require(verifyBatch(batchSize, epochFirstBl, programOutput[41], 0));

        Branch storage challengeChain = branches[numBranches];
        Batch storage genesisBatch = challengeChain.batchChain[
            challengeChain.numBatchChain++
        ];
        Batch storage batch = challengeChain.batchChain[
            challengeChain.numBatchChain
        ];
        challengeChain.startingAtBatchHeight = batchHeight;

        for (uint256 i = 1; i <= batchHeight - 1; i++) {
            challengeChain.length =
                challengeChain.length +
                branches[0].batchChain[i].batchSize;
            if (challengeChain.length % 2016 == 0) {
                challengeChain.firstBlockInEpoch = branches[0]
                    .batchChain[i]
                    .blockHeader;
            }
        }

        genesisBatch.cumDifficulty = branches[0]
            .batchChain[batchHeight - 1]
            .cumDifficulty;

        uint256[] memory tmp = new uint256[](5);
        tmp[0] = batchSize;
        tmp[1] = batchLastHash;
        tmp[2] = programOutput[64];
        tmp[3] = programOutput[65];
        tmp[4] = programOutput[41];
        createBatch(batchLastBl, challengeChain, batch, tmp);
        emit CreatedNewChallenge(numBranches);
        return numBranches++;
    }

    function addBatchToChallenge(
        uint256[] memory programOutput,
        uint256 challengeId
    ) public {
        bytes32 outputHash = keccak256(abi.encodePacked(programOutput));
        bytes32 fact = keccak256(
            abi.encodePacked(cairoProgramHash_, outputHash)
        );
        require(cairoVerifier_.isValid(fact), "MISSING_CAIRO_PROOF");

        uint256 batchSize = programOutput[0];
        Block memory epochFirstBl = parseBlock(programOutput, 1);
        Block memory batchFirstBl = parseBlock(programOutput, 21);
        Block memory batchLastBl = parseBlock(programOutput, 42); //42 instead of 41 because target recalculation variable is in line 41
        uint256 batchLastHash = programOutput[62] * 2**128 + programOutput[63];

        require(
            batchFirstBl.prev_block ==
                branches[challengeId]
                    .batchChain[branches[challengeId].numBatchChain - 1]
                    .headerHash,
            "Prev block hash is not correct"
        );

        require(verifyBatch(batchSize, epochFirstBl, programOutput[41], 0));

        Branch storage challengeChain = branches[challengeId];
        Batch storage batch = challengeChain.batchChain[
            challengeChain.numBatchChain
        ];
        uint256[] memory tmp = new uint256[](5);
        tmp[0] = batchSize;
        tmp[1] = batchLastHash;
        tmp[2] = programOutput[64];
        tmp[3] = programOutput[65];
        tmp[4] = programOutput[41];
        createBatch(batchLastBl, challengeChain, batch, tmp);

        emit AddedBatchToChallenge(
            challengeId,
            branches[challengeId].numBatchChain - 1
        );
    }

    function settleChallenge(uint256 challengeId) public {
        uint256 cumDifficulty_ChallengeChain = branches[challengeId]
            .batchChain[branches[challengeId].numBatchChain - 1]
            .cumDifficulty;
        uint256 cumDifficulty_MainChain = branches[0]
            .batchChain[branches[0].numBatchChain - 1]
            .cumDifficulty;
        require(
            cumDifficulty_ChallengeChain > cumDifficulty_MainChain,
            "Not enough proof of work on challenging chain."
        );

        Branch storage mainBranch = branches[0];
        Branch storage challengingBranch = branches[challengeId];
        for (
            uint256 i = branches[challengeId].startingAtBatchHeight;
            i <= branches[challengeId].numBatchChain;
            i++
        ) {
            // overwriting chain with blocks of challenging chain
            // +1 because of 'genesis block' on challenging chain
            mainBranch.batchChain[i].blockHeader = challengingBranch
                .batchChain[i - challengingBranch.startingAtBatchHeight + 1]
                .blockHeader;
            mainBranch.batchChain[i].batchSize = challengingBranch
                .batchChain[i - challengingBranch.startingAtBatchHeight + 1]
                .batchSize;
            mainBranch.batchChain[i].headerHash = challengingBranch
                .batchChain[i - challengingBranch.startingAtBatchHeight + 1]
                .headerHash;
            mainBranch.batchChain[i].cumDifficulty = challengingBranch
                .batchChain[i - challengingBranch.startingAtBatchHeight + 1]
                .cumDifficulty;
            mainBranch.batchChain[i].merkleRoot = challengingBranch
                .batchChain[i - challengingBranch.startingAtBatchHeight + 1]
                .merkleRoot;

            // deleting blocks from challenging chain as they are no longer needed
            delete challengingBranch.batchChain[
                i - challengingBranch.startingAtBatchHeight
            ];
        }

        mainBranch.length = challengingBranch.length;

        // update numBatchChain of main chain to new length
        // -1 because of 'genesis block' on challenging chain
        mainBranch.numBatchChain =
            challengingBranch.startingAtBatchHeight +
            challengingBranch.numBatchChain -
            1;

        delete branches[challengeId];
    }

    /*  inputs:
        0 - 19 -> intermediary block header that will be added to the batch
        20 - 21 -> its hash
        22 -> merkle root of the batch
    */

    //do not allow intermediary blocks on challenging chains
    function submitIntermediaryBlock(
        uint256[] memory programOutput,
        uint256 batchNo
    ) public {
        bytes32 outputHash = keccak256(abi.encodePacked(programOutput));
        bytes32 fact = keccak256(
            abi.encodePacked(merkleProgramHash_, outputHash)
        );
        require(cairoVerifier_.isValid(fact), "MISSING_CAIRO_PROOF");

        Batch storage batch = branches[0].batchChain[batchNo];

        require(
            batch.merkleRoot == programOutput[22],
            "Merkle roots do not equal"
        );
        uint256 headerHash = programOutput[20] * 2**128 + programOutput[21];
        batch.intermediaryHeader[headerHash] = parseBlock(programOutput, 0);
    }

    //rest: [batchSize, blockHash, target, merkleRoot, targetChangePos]
    function createBatch(
        Block memory header,
        Branch storage chain,
        Batch storage batch,
        uint256[] memory rest
    ) internal {
        uint256 difficulty = difficultyFromTarget(rest[2]);
        batch.headerHash = rest[1];
        if (
            rest[4] ==
            0x0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        ) {
            batch.cumDifficulty =
                chain.batchChain[chain.numBatchChain - 1].cumDifficulty +
                difficulty *
                rest[0];
        } else {
            uint256 oldDifficulty = difficultyFromTarget(
                chain.batchChain[chain.numBatchChain - 1].target
            );
            batch.cumDifficulty =
                chain.batchChain[chain.numBatchChain - 1].cumDifficulty +
                (rest[0] - rest[4]) *
                difficulty +
                oldDifficulty *
                rest[4];
            //NOTE above cumDifficulty is not ready for two epochs, possible approach:
            // use the average of old and new difficulty to estimate the difficulty
            // of the intermediary blocks of the skipped epoch
        }

        batch.merkleRoot = rest[3];
        batch.blockHeader = header;
        batch.batchSize = rest[0];
        batch.target = rest[2];
        chain.numBatchChain++;
        // if this batch lead into a new epoch update firstBlockInEpoch of the branch
        if ((chain.length + rest[0]) / EPOCH_SIZE > chain.length / EPOCH_SIZE) {
            chain.firstBlockInEpoch = header;
        }
        chain.length = chain.length + rest[0];
    }

    function difficultyFromTarget(uint256 target)
        private
        pure
        returns (uint256)
    {
        return
            0x00000000FFFF0000000000000000000000000000000000000000000000000000 /
            target;
    }

    function getLatestBlockHash(uint256 branchId)
        public
        view
        returns (uint256)
    {
        return
            branches[branchId]
                .batchChain[branches[branchId].numBatchChain - 1]
                .headerHash;
    }

    // hash must be little endian!
    function getBlockBlockHeader(
        uint256 batchNo,
        uint256 hash,
        uint256 chainId
    ) public view returns (Block memory header) {
        Batch storage batch = branches[chainId].batchChain[batchNo];
        if (batch.headerHash == hash) return batch.blockHeader;
        else return batch.intermediaryHeader[hash];
    }

    function getCumDifficulty(uint256 chainId)
        public
        view
        returns (uint256 difficulty)
    {
        return
            branches[chainId]
                .batchChain[branches[chainId].numBatchChain - 1]
                .cumDifficulty;
    }

    function getSubmittedBlockHeader(uint256 batchNo, uint256 chainId)
        public
        view
        returns (Block memory header)
    {
        return branches[chainId].batchChain[batchNo].blockHeader;
    }

    function getMerkleRoot(uint256 batchNo) public view returns (uint256) {
        return branches[0].batchChain[batchNo].merkleRoot;
    }

    function getFirstBlockInEpoch(uint256 chainId)
        public
        view
        returns (Block memory)
    {
        return branches[chainId].firstBlockInEpoch;
    }

    function getChainLength(uint256 chainId) public view returns (uint256) {
        return branches[chainId].length;
    }

    event CreatedNewChallenge(uint256 challengeId);
    event AddedBatchToChallenge(uint256 challengeId, uint256 batchHeight);
}
