#!/usr/bin/env python3

# Utreexo Bridge Node
#
# The Utreexo bridge node serves inclusion proofs to the STARK prover.
# The algorithms for `utreexo_add` and `utreexo_delete` are
# described in [the Utreexo paper](https://eprint.iacr.org/2019/611.pdf).
#
# Note that you have to run this in the python environment
# source ~/cairo_venv/bin/activate

from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import urlparse
import json

from starkware.cairo.lang.vm.crypto import pedersen_hash


# The array of trees in the forest
# [T_1, T_2, T_4, T_8, ... ]
root_nodes = [None] * 27

# The set of leaf nodes in the forest
leaf_nodes = dict()


# A node of the Utreexo forest
class Node:
    def __init__(self, key, left=None, right=None):
        self.val = key
        self.left = left
        self.right = right
        self.parent = None


# Compute the parent node of two nodes
def parent_node(root1, root2):
    root = pedersen_hash(root1.val, root2.val)
    root_node = Node(root, root1, root2)
    root1.parent = root_node
    root2.parent = root_node
    return root_node


# Add an element to the accumulator
def utreexo_add(leaf):
    if leaf in leaf_nodes:
        raise Exception('Leaf exists already')

    n = Node(leaf)
    leaf_nodes[leaf] = n
    h = 0
    r = root_nodes[h]
    while r is not None:
        n = parent_node(r, n)
        root_nodes[h] = None

        h = h + 1
        r = root_nodes[h]

    root_nodes[h] = n
    return root_nodes


# Delete an element from the accumulator
def utreexo_delete(leaf):
    leaf_node = leaf_nodes[leaf]
    del leaf_nodes[leaf]

    proof, leaf_index = inclusion_proof(leaf_node)

    n = None
    h = 0
    while h < len(proof):
        p = proof[h]  # Iterate over each proof element
        if n is not None:
            n = parent_node(p, n)
        elif root_nodes[h] is None:
            p.parent = None
            root_nodes[h] = p
        else:
            n = parent_node(p, root_nodes[h])
            root_nodes[h] = None
        h = h + 1

    # TODO: is this check necessary at all?
    if n is not None:
        n.parent = None

    root_nodes[h] = n

    proof = list(map(lambda node: hex(node.val), proof))
    return proof, leaf_index


# Compute a node's inclusion proof
def inclusion_proof(node):
    if node.parent is None:
        return [], 0

    parent = node.parent
    path, leaf_index = inclusion_proof(parent)

    if node == parent.left:
        path.insert(0, parent.right)
        leaf_index = leaf_index * 2
    else:
        path.insert(0, parent.left)
        leaf_index = leaf_index * 2 + 1

    return path, leaf_index


# The server handling the GET requests
# TODO: get rid of this hack
class RequestHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        self.send_response(200)
        self.end_headers()

        global root_nodes, leaf_nodes

        if self.path.startswith('/add'):
            hash_hex = self.path.replace('/add/', '')
            print('add', hash_hex)
            vout_hash = int(hash_hex, 16)
            utreexo_add(vout_hash)

            print('roots:', list(map(lambda node: hex(node.val).replace(
                '0x', '') if node is not None else 0, root_nodes)))

            self.wfile.write(json.dumps({'status': 'success'}).encode())
            return

        if self.path.startswith('/delete'):
            hash_hex = self.path.replace('/delete/', '')
            print('delete', hash_hex)
            vout_hash = int(hash_hex, 16)
            proof, leaf_index = utreexo_delete(vout_hash)
            print(proof, leaf_index)
            self.wfile.write(json.dumps(
                {'leaf_index': leaf_index, 'proof': proof}).encode())
            return

        if self.path.startswith('/reset'):
            print('>>>>>>>>>> RESET >>>>>>>>>>')
            root_nodes = [None] * 27
            leaf_nodes = dict()
            return


if __name__ == '__main__':
    server = HTTPServer(('localhost', 2121), RequestHandler)
    print('Starting bridge node at http://localhost:2121')
    server.serve_forever()
