# adopted from https://github.com/informartin/zkRelay/blob/master/preprocessing/create_input.py

from bitcoinrpc.authproxy import AuthServiceProxy


def getBitcoinClientURL(ctx):
    return f"http://{ctx.obj['btc-client']['user']}:{ctx.obj['btc-client']['psw']}@{ctx.obj['btc-client']['host']}:{ctx.obj['btc-client']['port']}"


def checkClientRunning(ctx):
    rpc_connection = AuthServiceProxy(getBitcoinClientURL(ctx))
    commands = [["getblockcount"]]
    try:
        _ = rpc_connection.batch_(commands)
    except:
        return False
    return True


def getBlockHashesInRange(ctx, i, j):
    rpc_connection = AuthServiceProxy(getBitcoinClientURL(ctx))
    commands = [["getblockhash", height] for height in range(i, j)]
    block_hashes = rpc_connection.batch_(commands)
    return block_hashes


def getBlockHeadersInRange(ctx, i, j):
    block_hashes = getBlockHashesInRange(ctx, i, j)
    rpc_connection = AuthServiceProxy(getBitcoinClientURL(ctx))
    blocks = rpc_connection.batch_([["getblockheader", h] for h in block_hashes])
    return blocks
