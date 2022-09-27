//
// To run only this test suite use:
// protostar test --cairo-path=./src target src/block/*_block.cairo
//
// Note that you have to run the bridge node to make all this tests pass
//

%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin

from python_utils import setup_python_defs
from transaction.transaction import TransactionValidationContext
from block.block_header import ChainState
from block.block import (
    BlockValidationContext,
    State,
    read_block_validation_context,
    validate_and_apply_block,
)
from utreexo.utreexo import utreexo_init, utreexo_add

from serialize.serialize import init_reader


// Create a dummy for the previous timestamps
func dummy_prev_timestamps() -> (timestamps: felt*) {
    let (prev_timestamps) = alloc();
    assert prev_timestamps[0] = 0;
    assert prev_timestamps[1] = 1;
    assert prev_timestamps[2] = 2;
    assert prev_timestamps[3] = 3;
    assert prev_timestamps[4] = 4;
    assert prev_timestamps[5] = 5;
    assert prev_timestamps[6] = 6;
    assert prev_timestamps[7] = 7;
    assert prev_timestamps[8] = 8;
    assert prev_timestamps[9] = 9;
    assert prev_timestamps[10] = 10;
    return (prev_timestamps,);
}

// Test a simple Bitcoin block with only a single transaction.
//
// Example: Block at height 6425
//
// - Block hash: 000000004d15e01d3ffc495df7bb638c2b35c5b5dd0ba405615f513e3393f0c7
// - Block explorer: https://blockstream.info/block/000000004d15e01d3ffc495df7bb638c2b35c5b5dd0ba405615f513e3393f0c7
// - Stackoverflow: https://stackoverflow.com/questions/67631407/raw-or-hex-of-a-whole-bitcoin-block
// - Blockchair: https://api.blockchair.com/bitcoin/raw/block/000000004d15e01d3ffc495df7bb638c2b35c5b5dd0ba405615f513e3393f0c7
@external
func test_verify_block_with_1_transaction{
    range_check_ptr, bitwise_ptr: BitwiseBuiltin*, pedersen_ptr: HashBuiltin*
}() {
    alloc_locals;
    setup_python_defs();

    // Create a dummy for the previous chain state
    let (prev_block_hash) = alloc();
    %{
        hashes_from_hex([
            "00000000ddc2c05eeaa044dcd039cd68c74f2747f8fe38b2f08a511634ead4a0"
        ], ids.prev_block_hash)
    %}

    let (prev_timestamps) = dummy_prev_timestamps();

    let prev_chain_state = ChainState(
        block_height=6424,
        total_work=0,
        best_block_hash=prev_block_hash,
        difficulty=0,
        epoch_start_time=0,
        prev_timestamps,
    );
    let (utreexo_roots) = utreexo_init();

    let prev_state = State(prev_chain_state, utreexo_roots);

    // Parse the block validation context
    let (context) = read_block_validation_context(prev_state);

    validate_and_apply_block{hash_ptr=pedersen_ptr}(context);
    return ();
}

func dummy_utxo_insert{hash_ptr: HashBuiltin*, utreexo_roots: felt*}(hash) {
    %{
        import urllib3
        http = urllib3.PoolManager()
        hex_hash = hex(ids.hash).replace('0x','')
        url = 'http://localhost:2121/add/' + hex_hash
        r = http.request('GET', url)
    %}

    utreexo_add(hash);
    return ();
}

func reset_bridge_node() {
    %{
        import urllib3
        http = urllib3.PoolManager()
        url = 'http://localhost:2121/reset/'
        r = http.request('GET', url)
    %}
    return ();
}

// Test a Bitcoin block with 4 transactions.
//
// Example: Block at height 100000
//
// - Block hash: 000000000003ba27aa200b1cecaad478d2b00432346c3f1f3986da1afd33e506
// - Block explorer: https://blockstream.info/block/000000000003ba27aa200b1cecaad478d2b00432346c3f1f3986da1afd33e506
// - Stackoverflow: https://stackoverflow.com/questions/67631407/raw-or-hex-of-a-whole-bitcoin-block
// - Blockchair: https://api.blockchair.com/bitcoin/raw/block/000000000003ba27aa200b1cecaad478d2b00432346c3f1f3986da1afd33e506
@external
func test_verify_block_with_4_transactions{
    range_check_ptr, bitwise_ptr: BitwiseBuiltin*, pedersen_ptr: HashBuiltin*
}() {
    alloc_locals;
    setup_python_defs();

    // Create a dummy for the previous chain state
    // Block 99999: https://blockstream.info/block/000000000002d01c1fccc21636b607dfd930d31d01c3a62104612a1719011250
    let (prev_block_hash) = alloc();
    %{
        hashes_from_hex([
            "000000000002d01c1fccc21636b607dfd930d31d01c3a62104612a1719011250"
        ], ids.prev_block_hash)
    %}

    let (prev_timestamps) = dummy_prev_timestamps();

    let prev_chain_state = ChainState(
        block_height=99999,
        total_work=0,
        best_block_hash=prev_block_hash,
        difficulty=0,
        epoch_start_time=0,
        prev_timestamps,
    );

    // We need some UTXOs to spend in this block
    reset_bridge_node();
    let (prev_utreexo_roots) = utreexo_init();
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(
        0x2d3ef8215980ca7bfe3aea785eb7a2f234eb33418ef4bc87683ca23287cd309
    );
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(
        0x1aa9272136be702146acae34cf02dfaed63288404e0e5842ae3b60341848779
    );
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(
        0x75f708000a3e08f9d6f01ced23f5e5d510bdf6dfa6d4447858586d4026b516e
    );

    let prev_state = State(prev_chain_state, prev_utreexo_roots);

    // Parse the block validation context using the previous state
    let (context) = read_block_validation_context(prev_state);

    // Sanity Check
    // The second output of the second transaction should be 44.44 BTC
    let transaction = context.transaction_contexts[1].transaction;
    assert transaction.outputs[1].amount = 4444 * 10 ** 6;

    // Validate the block
    let (next_state) = validate_and_apply_block{hash_ptr=pedersen_ptr}(context);

    %{
        # addr = ids.next_state.utreexo_roots
        # print('Next state root:', memory[addr], memory[addr + 1], memory[addr + 2], memory[addr + 3])
    %}
    return ();
}

// Test a Bitcoin block with 27 transactions.
//
// Example: Block at height 170000
//
// - Block hash: 000000000000051f68f43e9d455e72d9c4e4ce52e8a00c5e24c07340632405cb
// - Block explorer: https://blockstream.info/block/000000000000051f68f43e9d455e72d9c4e4ce52e8a00c5e24c07340632405cb
// - Blockchair: https://api.blockchair.com/bitcoin/raw/block/000000000000051f68f43e9d455e72d9c4e4ce52e8a00c5e24c07340632405cb
// @external
func test_verify_block_with_27_transactions{
    range_check_ptr, bitwise_ptr: BitwiseBuiltin*, pedersen_ptr: HashBuiltin*
}() {
    alloc_locals;
    setup_python_defs();

    // Create a dummy for the previous chain state
    // Block 299999: https://blockstream.info/block/000000000000096b85408520f97770876fc88944b8cc72083a6e6dca9f167b33
    let (prev_block_hash) = alloc();
    %{
        hashes_from_hex([
            "000000000000096b85408520f97770876fc88944b8cc72083a6e6dca9f167b33"
        ], ids.prev_block_hash)
    %}

    let (prev_timestamps) = dummy_prev_timestamps();

    let prev_chain_state = ChainState(
        block_height=169999,
        total_work=0,
        best_block_hash=prev_block_hash,
        difficulty=0,
        epoch_start_time=0,
        prev_timestamps,
    );

    // We need some UTXOs to spend in this block
    reset_bridge_node();
    let (utreexo_roots) = utreexo_init();
    
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x29404e0d83ef4665004ac7cfac4e21ceb341ca57b0750a94e32a9733f9bcc0d);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x35d7ecae60b518f080cc62ed0e2173cd652084e1103ef6c241239f826ac3ca8);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x4f04a0f4f25b63b75fc3aa485c11eda7a1e7a587b23430b628706d7fa92ffa);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x4e96c6aeac0c234f597c90fb00fad79380593d8901e85aa258d7f0ceef4626b);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x6ad571137d2dffc805bdc3e4d24b42b7f4bfdadf79f0018a812c44afe8afa14);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x5887ffa10f701abba2371155b123f9dd1b74288b9c4ace99c7eabd77f1b1a9a);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x413f5da54c88e408b6664f7df2a5bac8ea73283eb36c099b9cb45ec2e47dc50);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x45ee5f5ce31e10e61ab5ab81cd338ec5602fbcef036d27a836cbab10894fedd);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x4fb97efa8654b89d9771eb5cae28bfd8540c128db89f1df25e0463ec7a611b0);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x105bedc93c4c9b0883e91a1092d04ae7a1f25715f8a266a24851c74de42c825);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x444b0f17e0c26e00e0abb406bde4e98fba96b4b6a9aa5994b82e187289d03de);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x628c09f6182d1fc46385cfc6cfc750acf90f7ac0c1127c1765228ae2c142930);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x18bfd3834c7f0a80fa5dd6d832c9dc13e4412a7fa2ede8d1a36fd95013ff1e);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x38e438d9be73d32c8a5f0981610f75619e05f61e2242bde3dac7817ff8c7973);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x486479e2b652f262475ca2d956ee186ecde7b75681741271adeb819dbb7a3e4);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x29ff69f0f7123ea2653eaba7f65f033567b2ee537eab98422d18e3ac0f1f4d2);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x4c13067a35228b15991eeb7ab1a06a429d2b0e54d725d405adced078b142fb6);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x3dad36acb5b3425309df1555035e5a58c9235d4aad5d4e22544cf61974d1c92);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x775568addbd0b22429b3cfef9f40fadb03c6ef3319d0cfe866caf682713dba1);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x54cb4479b716784b76c8908f474f9708586b7fbaa97e861d8e1312af4908530);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x7698c879320edbeb338e5850accf0f2768dc92b86e94c1fe688ea1253f9be8a);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x2271a06cc6bcc7bc6d9bcecf10c4cf713b2a645e0b3de7a4a44555da1523c57);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x706687cd1b29f875f74e60be8b824d9f634c7583a65ff291e71a38265b2f75d);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x2153994cd66d9fe7337b675440b2f0a398883ad0afbc0498c33b7bd1425d6fa);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x21ebfc7f4d99fa94a19d2b9cd05d96d449bc3ab82c09dc9af577e86cce4f6e3);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x1bc7ac73b5ef33d6b03807cfac453377a139aa85cc2fa5a3cff3a86f3070983);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x3429c3773baa171009a666693353c5ddc4fa47c403dd735465702dd6d4d6389);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x931053f5dd4c49e398d3971b7ec0bbdde63296cb5b8d66fb1f6d5b756e89eb);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x1611260d5ab93495b4b9c5258b686369d648c78c475db6c181f6938c62c4bde);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x76cee025b1c057be050c1f3276eeefca353c91369633d9be3104ad916dd5fa7);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x77913c8d62d3a5b4d639c3a4456dfc2a31ba83ad019293cfeed82924b415836);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x19e0120dcccdb3750ba03f7b049bdd026c4479e753ae4a8514dc68df08da8f7);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x3f07b0576d4de43c41d6dbacd9a9138f36df3c3a8c5cb20b9630e816ce76e6b);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0xe5b21e313831cc53aa28a867df5d8437a5703c51501c8ae5176f054b2cd0e8);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x295386a42a82218d02d60a432ce18bfbb3cd05cd6adba14c6115fc6efa49553);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x7482fd2638a304185473d801c56dce4870f806c30fa1ed60c6c01def671ffdd);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x7dccada6a3e89a4f20dfdcafc076174ebf36939758a5adf40c7613596493d35);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x6e58b15d7a5e4171317d64f58676bc37b82921d68fb3fbab7d4762ec8f91cd5);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x77894e69c593676627114135cc18ce51d71ff0fefd4ef5ea793145fe032896f);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x4fb3d239a339bbba569d587de5ac3026c11dae56657e30510384535d90ce02c);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x38949febb0177d12daebd369e41254f86a204b48f4442cbb613a165a65a1f71);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x4fc1f8817bb99706e0586690e3cdb43b450677d524428eb6a0157515eaf655f);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x2844951e8e5c0358566214d98a6ca97bca2c3d15bbd86ea1d1bac285bcccde9);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x6470dabec026ae65212ab0b2dd6a7e01f1f24f4c5a62ce098695dc51e3216e9);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x4fa01ed687c072aaed07dc00ba76aed24120e87de6e9db9b099a7f2071503bf);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x6c05bcd2e99bce32738e27632ef9b2a121b4702e151d09d0eb11370a98070e);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x5e5dcfe3ae2843224503a7b62358fa6288b3b63f1ae0781df4d37ae7bd5e6a5);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x201a03fec89b4c57cb0630bcad21554d5e4d3bd235c6018e0f314437d20543b);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x2434cf2e7ac20ed6598123f810429b6746cd6b81328d015a89e310b58a07eea);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x3204f02e222140b9e21b4c643250bfed9bd47f31febddf6f391901515d74d1c);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x4ae452b1862d6fae5f32368bbbc09699e9bd70643a9eb719f2d8c2163aa43f);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x2dff43524183453a8cc98e1d842f81f65471eaf725fcdec54c4733c9c36ea58);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x7e9b047bbfbc93c3482a402b8c07d40af3e6c949d2f364da0e4bdfe69706134);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x13d9ee67f99c6e67487db1b4140acad1abee663c150f1fdbe48e8c6fc3c2a3f);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x39d6fbf274af78ca2e0a118c5cf9be841c831d189d1dded99654f7989f8c8d1);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x5155898bd769682cd2e435f10ede08c992e6010f7fa84f547365103d53fafaf);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x6279255c912ae8049d861f7ea431db7960f7ba381a9139745776f88681a6e92);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x6511e11ff4b4509c0b7272365d49b8632eb61e26826c2bea85815ab1c95ebea);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x1ef657ca5cd018a21771946ae0aae413cec13a2aec11bc145cf0aa2ea8ae978);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x2b7794e285f4221631f64df938dac36dea0575863cc675c08a1036f957134d);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x9b3f62091338b0e80780ceda4de88bdfe57a325bad36f28bff6f194bb44955);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x6016f4b04e9d8d296c504a03b51a4b70885169e644be5fb5571a806db6de8e4);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x65bd06a52fa1b7b843fcd5c3c337ca11551db63ff5be3a4507925308b677c7b);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x6a14ae995632b90d211b19a7774bed2a5a0721cafa3850f4e946aecdd4d877e);

    

    let prev_state = State(prev_chain_state, utreexo_roots);

    // Parse the block validation context using the previous state
    let (context) = read_block_validation_context(prev_state);

    // Sanity Check
    // Transaction count should be 27
    assert context.transaction_count = 27;

    // Sanity Check
    // The second output of the second transaction should be 54.46 BTC
    let transaction = context.transaction_contexts[1].transaction;
    assert transaction.outputs[1].amount = 5446 * 10 ** 6;

    // Validate the block
    validate_and_apply_block{hash_ptr = pedersen_ptr}(context);
    return ();
}









// Test a Bitcoin block with 49 transactions.
//
// Example: Block at height 170000
//
// - Block hash: 000000000000000009a11b3972c8e532fe964de937c9e0096b43814e67af3728
// - Block explorer: https://blockstream.info/block/000000000000000009a11b3972c8e532fe964de937c9e0096b43814e67af3728
// - Blockchair: https://api.blockchair.com/bitcoin/raw/block/000000000000000009a11b3972c8e532fe964de937c9e0096b43814e67af3728
// @external
func test_verify_block_with_49_transactions{
    range_check_ptr, bitwise_ptr: BitwiseBuiltin*, pedersen_ptr: HashBuiltin*
}() {
    alloc_locals;
    setup_python_defs();

    // Create a dummy for the previous chain state
    // Block 299999: https://blockstream.info/block/00000000000000000cca48eb4b330d91e8d946d344ca302a86a280161b0bffb6
    let (prev_block_hash) = alloc();
    %{
        hashes_from_hex([
            "00000000000000000cca48eb4b330d91e8d946d344ca302a86a280161b0bffb6"
        ], ids.prev_block_hash)
    %}

    let (prev_timestamps) = dummy_prev_timestamps();

    let prev_chain_state = ChainState(
        block_height=328733,
        total_work=0,
        best_block_hash=prev_block_hash,
        difficulty=0,
        epoch_start_time=0,
        prev_timestamps,
    );

    // We need some UTXOs to spend in this block
    reset_bridge_node();
    let (utreexo_roots) = utreexo_init();
    
    
    let prev_state = State(prev_chain_state, utreexo_roots);

    // Parse the block validation context using the previous state
    let (context) = read_block_validation_context(prev_state);

    // Sanity Check
    // Transaction count should be 49
    assert context.transaction_count = 49;

    // Sanity Check
    // The second output of the second transaction should be 1.83180058 BTC

    let transaction = context.transaction_contexts[1].transaction;
    assert transaction.outputs[1].amount = 183180058


    // Validate the block
    // validate_and_apply_block{hash_ptr = pedersen_ptr}(context);
    return ();
}
