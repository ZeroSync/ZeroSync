sed -i '1c#%builtins output pedersen range_check ecdsa bitwise' src/validate.cairo
protostar test ./tests --cairo-path=./src
sed -i '1c%builtins output pedersen range_check ecdsa bitwise' src/validate.cairo
