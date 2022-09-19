#!/usr/bin/env python3

from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import urlparse
import json

from starkware.cairo.lang.vm.crypto import pedersen_hash


# The array of trees in the forest
# [T_1, T_2, T_4, T_8, ... ]
root_nodes = [ None ] * 27

# The set of leaf nodes in the forest
leaf_nodes = dict()


# A node of the Utreexo forest
class Node:
    def __init__(self, key, left=None, right=None):
        self.parent = None
        self.left = left
        self.right = right
        self.val = key


# Compute the parent node of two nodes
def parent_node(root1, root2):
    root = pedersen_hash(root1.val, root2.val)
    root_node = Node(root, root1, root2)
    root1.parent = root_node
    root2.parent = root_node
    return root_node 


# Add an element to the accumulator
def utreexo_add(hash_hex):
    print('add', hash_hex)
    leaf = int(hash_hex, 16)

    if leaf in leaf_nodes:
        raise Exception('Leaf exists already')
    n = Node(leaf)
    leaf_nodes[leaf] = n
    h = 0 
    r = root_nodes[h]
    while r != None:
        n = parent_node(r, n)
        root_nodes[h] = None
        
        h = h + 1
        r = root_nodes[h]

    root_nodes[h] = n
    return root_nodes


# Compute a node's inclusion proof
def inclusion_proof(node):
    if node.parent == None:
        return [], 0
    
    parent = node.parent
    proof, tree_index = inclusion_proof(parent)

    if node == parent.left:
        proof.append(parent.right)
        tree_index = tree_index * 2 
    else:
        proof.append(parent.left)
        tree_index = tree_index * 2 + 1

    return proof, tree_index


# Delete an element from the accumulator
def utreexo_delete(hash_hex):
    print('delete', hash_hex)
    leaf = int(hash_hex, 16)

    leaf_node = leaf_nodes[leaf]
    del leaf_nodes[leaf]

    proof, tree_index = inclusion_proof(leaf_node)

    n = None
    h = 0
    while h < len(proof):
        p = proof[h] # Iterate over each proof element
        if n != None:
            n = parent_node(p, n)
        elif root_nodes[h] == None:
            p.parent = None
            root_nodes[h] = p
        else:
            n = parent_node(p, root_nodes[h])
            root_nodes[h] = None
        h = h + 1

    root_nodes[h] = n

    proof = list(map(lambda node: hex(node.val), proof))
    return proof, tree_index



def compute_leaf_index():
    print('Implement me')


# The server handling the GET requests
class RequestHandler(BaseHTTPRequestHandler):
    
    def do_GET(self):
        self.send_response(200)
        self.end_headers()

        if self.path.startswith('/add'):
            vout_hash = self.path.replace('/add/','')
            utreexo_add(vout_hash)
            self.wfile.write(b'element added')
            return

        if self.path.startswith('/delete'):
            vout_hash = self.path.replace('/delete/','')
            proof, tree_index = utreexo_delete(vout_hash)
            self.wfile.write(json.dumps({'leaf_index': tree_index, 'proof': proof }).encode())
            return 


if __name__ == '__main__':
    server = HTTPServer(('localhost', 2121), RequestHandler)
    print('Starting server at http://localhost:2121')
    server.serve_forever()