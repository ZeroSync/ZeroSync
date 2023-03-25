#!/usr/bin/env python3

# Headers Merkle Tree Bridge Node
#
# This Node serves Merkle paths for the headers chain proof
#
# Note that you have to run this in the python environment
# source ~/cairo_venv/bin/activate

from http.server import BaseHTTPRequestHandler, HTTPServer
import json
import urllib3
import re

from starkware.cairo.lang.vm.crypto import pedersen_hash

# The set of leaf nodes in the tree
leaf_nodes = []


class Node:
    def __init__(self, key, left=None, right=None):
        self.val = key
        self.left = left
        self.right = right
        self.parent = None


# Compute the parent node of two nodes
def parent_node(node1, node2):
    root = pedersen_hash(node1.val, node2.val)
    root_node = Node(root, node1, node2)
    node1.parent = root_node
    node2.parent = root_node
    return root_node


def build_tree():
    nodes = []
    for leaf_node in leaf_nodes:
        nodes.append(leaf_node)

    while (len(nodes) > 1):
        next_nodes = []
        if len(nodes) % 2 != 0:
            nodes.append(Node(0))
        for i in range(0, len(nodes), 2):
            node1 = nodes[i]
            node2 = nodes[i + 1]
            next_nodes.append(parent_node(node1, node2))
        nodes = next_nodes
    return nodes[0]


# Add an element to the accumulator
def add_node(leaf):
    if leaf in leaf_nodes:
        raise Exception('Leaf exists already')

    n = Node(leaf)
    leaf_nodes.append(n)


def add_nodes(leaves):
    for leaf in leaves:
        add_node(leaf)


# Compute a node's inclusion proof
def inclusion_proof(node):
    if node.parent is None:
        return []

    parent = node.parent
    path = inclusion_proof(parent)

    if node == parent.left:
        path.insert(0, parent.right)
    else:
        path.insert(0, parent.left)

    return path


def get_block_header(block_height):
    http = urllib3.PoolManager()

    url = 'https://blockstream.info/api/block-height/' + \
        str(block_height)
    r = http.request('GET', url)
    block_hash = str(r.data, 'utf-8')

    url = f'https://blockstream.info/api/block/{ block_hash }'
    r = http.request('GET', url)
    return r.data


def get_block_headers(start, end):
    headers = []
    for i in range(start, end):
        headers[i] = get_block_header(block_height)
    return headers


def hex_to_felt(hex_string):
    # Seperate hex_string into chunks of 8 chars.
    felts = re.findall(".?.?.?.?.?.?.?.", hex_string)
    # Fill remaining space in last chunk with 0.
    while len(felts[-1]) < 8:
        felts[-1] += "0"
    return [int(x, 16) for x in felts]


# Has to be the same hashing procedure as in src/block/block_header.cairo
# TODO refactor for readability or keep as is (very close to how cairo
# implementation looks)?
def hash_block_header(header):
    BASE = 2 ** 32
    prev_block_hash = hex_to_felt(
        header.previousblockhash) if header.previousblockhash != null else 0
    merkle_root_hash = hex_to_felt(header.merkle_root)
    tmp1 = header.version * BASE ** 0 + \
        prev_block_hash[0] * BASE ** 1 + \
        prev_block_hash[1] * BASE ** 2 + \
        prev_block_hash[2] * BASE ** 3 + \
        prev_block_hash[3] * BASE ** 4 + \
        prev_block_hash[4] * BASE ** 5 + \
        prev_block_hash[5] * BASE ** 6
    tmp2 = prev_block_hash[6] * BASE ** 0 + \
        prev_block_hash[7] * BASE ** 1 + \
        merkle_root_hash[0] * BASE ** 2 + \
        merkle_root_hash[1] * BASE ** 3 + \
        merkle_root_hash[2] * BASE ** 4 + \
        merkle_root_hash[3] * BASE ** 5 + \
        merkle_root_hash[4] * BASE ** 6
    tmp3 = merkle_root_hash[5] * BASE ** 0 + \
        merkle_root_hash[6] * BASE ** 1 + \
        merkle_root_hash[7] * BASE ** 2 + \
        header.timestamp * BASE ** 3 + \
        header.bits * BASE ** 4 + \
        header.nonce * BASE ** 5
    tmp_hash = pedersen_hash(tmp1, tmp2)
    pedersen_block_hash = pedersen_hash(tmp_hash, tmp3)
    return pedersen_block_hash


# The server handling the GET requests
class RequestHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        self.send_response(200)
        self.end_headers()

        global leaf_nodes

        # Meant to be called in every
        if self.path.startswith('/create'):
            block_height = self.path.replace('/create/', '')
            print('create', block_height)
            headers = get_block_headers(0, block_height + 1)
            header_hashes = [hash_block_header(header) for header in headers]
            if len(header_hashes) % 2 == 1:
                header_hashes.append(0)
            add_nodes(header_hashes)
            tree_root = build_tree()
            self.wfile.write(json.dumps(
                {'root': tree_root, 'status': 'success'}).encode())
            return

        # TODO: refactor and remove leaf_index and replace None with 0
        if self.path.startswith('/merkle_path'):
            node_index = self.path.replace('/merkle_path/', '')
            print('merkle_path', node_index)
            if node_index > len(leaf_nodes):
                proof = []
            elif node_index == len(lead_nodes):
                # TODO remove everything until we hit a zero
                proof = inclusion_proof(leaf_nodes(node_index-1).parent)
            else:
                proof = inclusion_proof(leaf_nodes(node_index))
            self.wfile.write(json.dumps(
                {'proof': proof, 'status': 'success'}).encode())
            return

        if self.path.startswith('/reset'):
            print('>>>>>>>>>> RESET >>>>>>>>>>')
            leaf_nodes = []
            return


if __name__ == '__main__':
    add_nodes([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12])
    root = build_tree()
    print("root:", hex(root.val))
    print([hex(x.val) for x in inclusion_proof(leaf_nodes[12-1].parent)])

    # server = HTTPServer(('localhost', 2122), RequestHandler)
    # print('Starting bridge node at http://localhost:2122')
    # server.serve_forever()
