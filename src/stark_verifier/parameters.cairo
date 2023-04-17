// Multiplicative generator for field with modulus $2^{251} + 17 \cdot 2^{192} + 1$
const MULTIPLICATIVE_GENERATOR = 3;

// 2-adic root of unity for field with modulus $2^{251} + 17 \cdot 2^{192} + 1$
const TWO_ADICITY = 192; 
const TWO_ADIC_ROOT_OF_UNITY = 145784604816374866144131285430889962727208297722245411306711449302875041684;

// NOTE: NUM_BUILTINS = len(json.load(open(COMPILED_PROGRAM))["builtins"])
const NUM_BUILTINS = 6; // output pedersen range_check ecdsa bitwise ec_op
const NUM_QUERIES = 54;
const FOLDING_FACTOR = 8;
