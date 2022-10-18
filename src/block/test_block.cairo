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


// Insert elements into the UTXO set to consume them in a block test
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


// Flash the UTXO set of the bridge node
func reset_bridge_node() {
    %{
        import urllib3
        http = urllib3.PoolManager()
        url = 'http://localhost:2121/reset/'
        r = http.request('GET', url)
        %}
    return ();
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
    reset_bridge_node();

    // Create a dummy for the previous chain state
    let (prev_block_hash) = alloc();
    %{
        hashes_from_hex([
                "00000000ddc2c05eeaa044dcd039cd68c74f2747f8fe38b2f08a511634ead4a0"
        ], ids.prev_block_hash)
            %}

    let (prev_timestamps) = dummy_prev_timestamps();

    let prev_chain_state = ChainState(
            block_height = 6424,
            total_work = 0,
            best_block_hash = prev_block_hash,
            current_target = 0x1d00ffff,
            epoch_start_time = 0,
            prev_timestamps,
            );
    let (utreexo_roots) = utreexo_init();

    let prev_state = State(prev_chain_state, utreexo_roots);

    // Parse the block validation context
    let (context) = read_block_validation_context(prev_state);

    validate_and_apply_block{hash_ptr=pedersen_ptr}(context);
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
    reset_bridge_node();

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
            current_target=0x1b04864c,
            epoch_start_time=0,
            prev_timestamps,
            );

    // We need some UTXOs to spend in this block

    let (roots) = utreexo_init();
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(
            0x2d3ef8215980ca7bfe3aea785eb7a2f234eb33418ef4bc87683ca23287cd309
            );
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(
            0x1aa9272136be702146acae34cf02dfaed63288404e0e5842ae3b60341848779
            );
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(
            0x75f708000a3e08f9d6f01ced23f5e5d510bdf6dfa6d4447858586d4026b516e
            );

    let prev_state = State(prev_chain_state, roots);

    // Parse the block validation context using the previous state
    let (context) = read_block_validation_context(prev_state);

    // Sanity Check
    // The second output of the second transaction should be 44.44 BTC
    let transaction = context.transaction_contexts[1].transaction;
    assert transaction.outputs[1].amount = 4444 * 10 ** 6;

    // Validate the block
    let (next_state) = validate_and_apply_block{hash_ptr=pedersen_ptr}(context);

    return ();
}


// Test a Bitcoin block with 27 transactions.
//
// Example: Block at height 170000
//
// - Block hash: 000000000000051f68f43e9d455e72d9c4e4ce52e8a00c5e24c07340632405cb
// - Block explorer: https://blockstream.info/block/000000000000051f68f43e9d455e72d9c4e4ce52e8a00c5e24c07340632405cb
// - Blockchair: https://api.blockchair.com/bitcoin/raw/block/000000000000051f68f43e9d455e72d9c4e4ce52e8a00c5e24c07340632405cb
@external
func test_verify_block_with_27_transactions{
    range_check_ptr, bitwise_ptr: BitwiseBuiltin*, pedersen_ptr: HashBuiltin*
}() {
    alloc_locals;
    setup_python_defs();
    reset_bridge_node();

    // Create a dummy for the previous chain state
    // Block 169999: https://blockstream.info/block/000000000000096b85408520f97770876fc88944b8cc72083a6e6dca9f167b33
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
            current_target=0x1a0b350c,
            epoch_start_time=0,
            prev_timestamps,
            );

    // We need some UTXOs to spend in this block
    reset_bridge_node();
    let (roots) = utreexo_init();

    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x29404e0d83ef4665004ac7cfac4e21ceb341ca57b0750a94e32a9733f9bcc0d);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x35d7ecae60b518f080cc62ed0e2173cd652084e1103ef6c241239f826ac3ca8);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x4f04a0f4f25b63b75fc3aa485c11eda7a1e7a587b23430b628706d7fa92ffa);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x4e96c6aeac0c234f597c90fb00fad79380593d8901e85aa258d7f0ceef4626b);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x6ad571137d2dffc805bdc3e4d24b42b7f4bfdadf79f0018a812c44afe8afa14);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x5887ffa10f701abba2371155b123f9dd1b74288b9c4ace99c7eabd77f1b1a9a);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x413f5da54c88e408b6664f7df2a5bac8ea73283eb36c099b9cb45ec2e47dc50);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x45ee5f5ce31e10e61ab5ab81cd338ec5602fbcef036d27a836cbab10894fedd);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x4fb97efa8654b89d9771eb5cae28bfd8540c128db89f1df25e0463ec7a611b0);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x105bedc93c4c9b0883e91a1092d04ae7a1f25715f8a266a24851c74de42c825);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x444b0f17e0c26e00e0abb406bde4e98fba96b4b6a9aa5994b82e187289d03de);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x628c09f6182d1fc46385cfc6cfc750acf90f7ac0c1127c1765228ae2c142930);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x18bfd3834c7f0a80fa5dd6d832c9dc13e4412a7fa2ede8d1a36fd95013ff1e);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x38e438d9be73d32c8a5f0981610f75619e05f61e2242bde3dac7817ff8c7973);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x486479e2b652f262475ca2d956ee186ecde7b75681741271adeb819dbb7a3e4);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x29ff69f0f7123ea2653eaba7f65f033567b2ee537eab98422d18e3ac0f1f4d2);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x4c13067a35228b15991eeb7ab1a06a429d2b0e54d725d405adced078b142fb6);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x3dad36acb5b3425309df1555035e5a58c9235d4aad5d4e22544cf61974d1c92);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x775568addbd0b22429b3cfef9f40fadb03c6ef3319d0cfe866caf682713dba1);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x54cb4479b716784b76c8908f474f9708586b7fbaa97e861d8e1312af4908530);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x7698c879320edbeb338e5850accf0f2768dc92b86e94c1fe688ea1253f9be8a);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x2271a06cc6bcc7bc6d9bcecf10c4cf713b2a645e0b3de7a4a44555da1523c57);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x706687cd1b29f875f74e60be8b824d9f634c7583a65ff291e71a38265b2f75d);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x2153994cd66d9fe7337b675440b2f0a398883ad0afbc0498c33b7bd1425d6fa);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x21ebfc7f4d99fa94a19d2b9cd05d96d449bc3ab82c09dc9af577e86cce4f6e3);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x1bc7ac73b5ef33d6b03807cfac453377a139aa85cc2fa5a3cff3a86f3070983);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x3429c3773baa171009a666693353c5ddc4fa47c403dd735465702dd6d4d6389);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x931053f5dd4c49e398d3971b7ec0bbdde63296cb5b8d66fb1f6d5b756e89eb);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x1611260d5ab93495b4b9c5258b686369d648c78c475db6c181f6938c62c4bde);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x76cee025b1c057be050c1f3276eeefca353c91369633d9be3104ad916dd5fa7);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x77913c8d62d3a5b4d639c3a4456dfc2a31ba83ad019293cfeed82924b415836);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x19e0120dcccdb3750ba03f7b049bdd026c4479e753ae4a8514dc68df08da8f7);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x3f07b0576d4de43c41d6dbacd9a9138f36df3c3a8c5cb20b9630e816ce76e6b);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0xe5b21e313831cc53aa28a867df5d8437a5703c51501c8ae5176f054b2cd0e8);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x295386a42a82218d02d60a432ce18bfbb3cd05cd6adba14c6115fc6efa49553);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x7482fd2638a304185473d801c56dce4870f806c30fa1ed60c6c01def671ffdd);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x7dccada6a3e89a4f20dfdcafc076174ebf36939758a5adf40c7613596493d35);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x6e58b15d7a5e4171317d64f58676bc37b82921d68fb3fbab7d4762ec8f91cd5);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x77894e69c593676627114135cc18ce51d71ff0fefd4ef5ea793145fe032896f);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x4fb3d239a339bbba569d587de5ac3026c11dae56657e30510384535d90ce02c);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x38949febb0177d12daebd369e41254f86a204b48f4442cbb613a165a65a1f71);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x4fc1f8817bb99706e0586690e3cdb43b450677d524428eb6a0157515eaf655f);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x2844951e8e5c0358566214d98a6ca97bca2c3d15bbd86ea1d1bac285bcccde9);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x6470dabec026ae65212ab0b2dd6a7e01f1f24f4c5a62ce098695dc51e3216e9);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x4fa01ed687c072aaed07dc00ba76aed24120e87de6e9db9b099a7f2071503bf);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x6c05bcd2e99bce32738e27632ef9b2a121b4702e151d09d0eb11370a98070e);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x5e5dcfe3ae2843224503a7b62358fa6288b3b63f1ae0781df4d37ae7bd5e6a5);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x201a03fec89b4c57cb0630bcad21554d5e4d3bd235c6018e0f314437d20543b);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x2434cf2e7ac20ed6598123f810429b6746cd6b81328d015a89e310b58a07eea);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x3204f02e222140b9e21b4c643250bfed9bd47f31febddf6f391901515d74d1c);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x4ae452b1862d6fae5f32368bbbc09699e9bd70643a9eb719f2d8c2163aa43f);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x2dff43524183453a8cc98e1d842f81f65471eaf725fcdec54c4733c9c36ea58);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x7e9b047bbfbc93c3482a402b8c07d40af3e6c949d2f364da0e4bdfe69706134);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x13d9ee67f99c6e67487db1b4140acad1abee663c150f1fdbe48e8c6fc3c2a3f);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x39d6fbf274af78ca2e0a118c5cf9be841c831d189d1dded99654f7989f8c8d1);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x5155898bd769682cd2e435f10ede08c992e6010f7fa84f547365103d53fafaf);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x6279255c912ae8049d861f7ea431db7960f7ba381a9139745776f88681a6e92);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x6511e11ff4b4509c0b7272365d49b8632eb61e26826c2bea85815ab1c95ebea);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x1ef657ca5cd018a21771946ae0aae413cec13a2aec11bc145cf0aa2ea8ae978);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x2b7794e285f4221631f64df938dac36dea0575863cc675c08a1036f957134d);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x9b3f62091338b0e80780ceda4de88bdfe57a325bad36f28bff6f194bb44955);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x6016f4b04e9d8d296c504a03b51a4b70885169e644be5fb5571a806db6de8e4);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x65bd06a52fa1b7b843fcd5c3c337ca11551db63ff5be3a4507925308b677c7b);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=roots}(0x6a14ae995632b90d211b19a7774bed2a5a0721cafa3850f4e946aecdd4d877e);



    let prev_state = State(prev_chain_state, roots);

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
// Example: Block at height 328734
//
// - Block hash: 000000000000000009a11b3972c8e532fe964de937c9e0096b43814e67af3728
// - Block explorer: https://blockstream.info/block/000000000000000009a11b3972c8e532fe964de937c9e0096b43814e67af3728
// - Blockchair: https://api.blockchair.com/bitcoin/raw/block/000000000000000009a11b3972c8e532fe964de937c9e0096b43814e67af3728
@external
func test_verify_block_with_49_transactions{
    range_check_ptr, bitwise_ptr: BitwiseBuiltin*, pedersen_ptr: HashBuiltin*
}() {
    alloc_locals;
    setup_python_defs();

    // Create a dummy for the previous chain state
    // Block 328733: https://blockstream.info/block/00000000000000000cca48eb4b330d91e8d946d344ca302a86a280161b0bffb6
    let (prev_block_hash) = alloc();
    %{
        hashes_from_hex([
                "00000000000000000cca48eb4b330d91e8d946d344ca302a86a280161b0bffb6"
        ], ids.prev_block_hash)
            %}

    let (prev_timestamps) = dummy_prev_timestamps();

    let prev_chain_state = ChainState(
            block_height = 328733,
            total_work = 0,
            best_block_hash = prev_block_hash,
            current_target = 0x181bc330,
            epoch_start_time = 0,
            prev_timestamps,
            );

    // We need some UTXOs to spend in this block
    reset_bridge_node();
    let (prev_utreexo_roots) = utreexo_init();

    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x4486fc74ae621af7db87af1e297deb6ee53aab72d133024d7c50c23b5d249de);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x273fab909513005e619ea0ef1d5829f67df6dd8d88ecaeb26459e237007776f);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x28cf7298f4d0ae98ed2df7d195b72a06e546b86907eb29c1bea42f6c9971427);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x7be63f527711eabf8851daa1e2b53a84fa7f6727885b31f0ceba8f44340febd);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x37db9963218a39f8860d2e263e18318a9f5490373da5f84585a49f9d55aa8ac);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x4582196069fcbd27cb18a27f9ab2d937f03e049ef7b31f5319cb97fa5a147ec);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x76df64a2854ed27be4b82eadf28953268ccc86d37b53034eedd1438ac87d0b8);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x56500108af31de329fd26c314eccd3f50baa9ca16dd1a812e95a03e3f747370);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x5124193615e561202fca0d3080b842b86a740cd1e86756694b380d7cc37f34f);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x599a6d86cd06268f7e9b123389ac18e34a7ca7d5775479a961f6fe91c74ac29);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x599f315bcfe5ddb120d7c0e157b6e2623338d18fa02f786784cdabaaf109912);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x22a8d2eba49e81e93d437d91f3995140fe821a1cef30f393f23629fb242d602);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x3dca7152fe9c5948d8c37b40a724b7865ab46a72d75e9cbb06f519d140a579e);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x1552a3cb31a07ecc89fe647a5e8761654ef8fa682dc8f1e3de6181dddc3e348);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x726e1dfc87c5cf7cc0f6006e99c7d2fd1766b794ceed63c0b699e1c89012a19);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x1fcc28e7405d686575a4f2f0f15e5580a82f3f90fd6312c1cad695c078617bf);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x685ba46fee89f183b4e4eba5ba3909ea956ac4f9ed7edd7c866db50c776a061);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x598132905dba6502d4aa0e368daed77f16f3fa9067586a4ee81a15a7c93298f);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x37e6970251cfd87e821eca5a2b5d006927e5689405106f333a2d659d67247f5);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x1a0c43becde5075740c9e117bdec5c76774214dc8b7480cd1064327f5e1ce45);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x18b5b2f886cad448e0cc98e769e53169e52276e1b9b0ea98ad7dc38d8aaca5);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x2e429f50e8110c436b17d9886c4bb777e42cf9dce53ab925506871afc59aae2);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0xf793dcce055422de5730ff0205d05524dfb8945b4679bb83b9e68eaca35425);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x6d0512316959038918214a4ceb0db2a1c4bea67a8de5960c6f289d381a3fea7);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x142448c2e82d9b6263e679a84c2e309ebe471e09040499acdcac598e25bb4a);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x1cbc8b89d79a768a15c70340b0a44dd81f9dcafca8350d3d2e6831f6768a190);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x2437ffe547c9c54af41907148d1fa458ae3dc5ab64a09a97de8d472b14f2be8);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x3772db61342d5fd0cfc83d6b6ece26f8bb442928660b8d04426a091e8cbf334);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x6e3fed6ec6f8230a6011b86c5f426accebc284e0dd137109d810c6e9fb2e266);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x1a285a96c61a824caa480deda67e1d68004f120f5ccd631532d66be5285e32a);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x797f67f6b73671413b7d83e180f01d5bc673a261d92b25dbbd58889ff19bf1f);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x200b992eec457ded137da49d4bf2eb63b560114b368ef906201939e425dd94b);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x605b18109f03ab2fcd0b97dc9fdd91d139baffd7e7b7bbf5c062990b00a5196);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x4d2db8dc5d9ebbf127196ee5b607600eca82632ce3f59b154a096979fdcff);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x197166459a1f4fb726645142da2e5fe01a5d723013759ef386d15d31a1bf503);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x433dd3edf046cd971fd64894dc6154a00cc182d0544779f9cf69d3a42ff6690);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x76262803eba0019c6ddbf9bf9e5ddf7f009b8afcb9076489a20e3389827e722);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x456f4f31b28851b0721a5c631fff46e7483ed14e754a21aa3bf692ce5776aa0);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x51eca2c7f39893f70a5fdf99c921a78047e8332fd442d5abbffdd4714f5c1dc);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x75f51e7affb4879cfbc2cae3e8fe6541198b714947838345be29f6692997502);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x53a62f320a628408c43f26a938c6f95c1f45b38e0a0d43257d8e2d79625e34e);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x3788bd64f58a2fb9cdab84003570b6816c384897c1d4bbf1f13afd807f1b511);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x513b37ff39cbd20fc4e5a165a5a8f102edb38e2ecb3eb4015a3be0586538a2a);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x3259eb17973b6a8f3db97730d7ff337f3f2454f624272e7951e4fdf06dcdc7c);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0xfe6f78699dd3dc87ee6127b2f70d78cc8e42c0135d42217f39699d38c98a70);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x37b9ceec2e86bcd24b6583d6b28b878c4bb44752147b1fb2425f4f177fda5ec);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x3688b67bc84d5a79f7abce45c2e48169537270ba6508c918885663780aa958b);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x8f339523edc31c5b18efdcaa19ffa521b575c77bac4289c1d556ba6b057cc9);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x707aea476397e3ea2dc164656811decab9b804148d868577622e073c02a6cb1);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x4eb83c6282ad84ae50dd79f91b38244f4537296b8fbbfdd62b837750c3071dc);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x7f83bdb2dcfb2aa787d3616518a95450eb76e5b9f6aaea4d5b59bbcff8dbf48);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0xd94c06a547219534191710156a13121e0f9e82177df9a6fba6168884cc4461);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x1810784c5076499fa40be006ee18893a0b557d9686dbe806b43b540149f1aef);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0xba964f49bb762e1be6b68b52b0c9b5f50ef9920f010d018ca8753e51379479);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x180fc5bab7036e67072f6500a02a751b07ce88a5799834c3fc56e1659b0940e);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x3db824398f085b0f0dcd2b4114b09e8a9d6f0d9b672fecab2f06541f3621b9d);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x6d1f324672450cb6b12422590e617f393ed5c8025963784b800880ae7225ea);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0xc5297bd7abcd514a54d4b1da5fccffa4055df6c0e37b4aa91ee376ca29775d);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x1ec3750bde577d13e905f23c0512a0cb39c42f7c201eceae8f67dd908d922c8);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x329a3687ef46c06f61cabfa46283299b293b5080dcc4c6ad9855962e9ab984c);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x5219c13384a232a8f05a0029ab34ffb901287c78cce2e92185fd02273eaa3ec);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0xf6dc407c607c47d4c81fd13d2d729147d4b516228fffa374133c1706e104fb);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x15ed2ad5941c0f2b7c7b467d4cbb921d1b63b901d9c428844e4a37940f575b5);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x70fa66629e064004ea57c4f1f2c03e97f87de542914f50688310b574face40e);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x33451ecede202bd800ace2b7ddda7e06dc7c1fdb0c4afa1fe2a0c22a5ff3eb6);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x2f932976bfc465f21b67b3b5221672033236066a958e66ab01a86fdb350164d);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x64c8110baf6acaa5b620bd162eb62fde5067d9ab7cfc980f0dbee7067cd7b39);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x624d76cb5530b2ed966d73687a7277f033734cdf8ff63b420d3c274b69887f0);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x145c781712ebfcf38ebea5f2bba1f21549c18c58e43cf963412c1ca5c80c30);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x84a0921a693d1a4e5f5228c041541876bc2f63d5cd386f3daebc7b60eeb6bc);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x4d695730ad9739ddb520e5d73b631678abea77a302441a83d454d8e3fc1a3dc);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x63f371e2258ec6f6ba160a71b6428f89fd6a7b1aecfda4e4c50d45f1c51258d);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x16f34a7b82f135914887f168cb744a2dfd5591e7785c23924e02b26abeb9bf3);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x739236393fddda16c456a239d3e7ab9bbfa2a8f048bf73d2b12b65732530cdb);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x3e937152fc9de6cb6bb5a83f24dd561a647ddac4bf1801893ecffc508b54388);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x36ff7640eb7a3ad3e314662913b231185d50f888d26ebac20565aa26858a834);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0xa2d786f28c4bef561d0a2bbb12273c87908aea56a3a295113b919a49827431);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x74978060e87add9f42e0e3e4f18f05df4bf04f1679434f1430c21417ab4ea73);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x7483caac4746e14437d52d5fcdb97dd97750241371ce763327e8c7354a948f7);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x2be024fc192f0dd603fe6ca7b8100860309bc20370a284019698b37cbb242e6);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x378ff7a273a1f1b8e4c1531b05c30a6de88d2206e93c0b0070341f519b8fd2c);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x522f413d0471789d593e822c4efb7295181aea858e5787bba3c69c00da57ab2);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0xb5b9721fa0d0da59ce43c6a8840b703b4bdc478130e8c2b4fed50177734129);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x1dac8cbe734ae1b886cf17b76d1692eaa39a1306c6c64eaa1603c1c44e73df8);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x2168be5e7f888eaf706a1aa2ce9f238611176a45499c50a714f8fd7652ff51);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x3fb86d9a8d416e8278f846fd57cfd56b525394282ee12ca4205afd6687d0034);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x2551dde498ef0ba6b32de6d5af2b088dcce842755e85a6be3dc2c2dba7526b7);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x4ab57e70c49e4d12ed46af333efa53fc21fd451fbb0d9c34640f5edf6c06d85);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x72c4d4dbd2b8cd2d105ca00085b61aba9489dfe10c833154dfe4aaedffb55db);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x512d490cb0c14032b0c587f5b82dc7668ee4d6b9cba8ca55f9947111df923a7);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x2d9a9f73f1e7ec6d282c07d4afdbca77c547af3c9301ef702e19619a52d1b6);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x53fcc1c6151d28edfc5aa0cc9e6c85d9493399a1acdb692671904788257cc6a);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x342235d44e9f29689fe993bbc68d226fc415b34053d1549bc8c2a2f178bf4f1);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x2c0467c06504bf986c56f5bb397512bdecece37163b2362187bc691cf521e61);
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(0x3d03ecce0543864d112fbc855e7a368acaf1c144061f3b057fcceae51bc0c20);
 
    let prev_state = State(prev_chain_state, prev_utreexo_roots);

    // Parse the block validation context using the previous state
    let (context) = read_block_validation_context(prev_state);

    // Sanity Check
    // Transaction count should be 49
    assert context.transaction_count = 49;

    // Sanity Check
    // The second output of the second transaction should be 0.11883137 BTC

    let transaction = context.transaction_contexts[1].transaction;
    assert transaction.outputs[1].amount = 11883137;


    // Validate the block
    validate_and_apply_block{hash_ptr = pedersen_ptr}(context);
    return ();
}
