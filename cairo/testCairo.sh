sed -i '1c#%builtins output pedersen range_check ecdsa bitwise' src/validate.cairo
protostar test --cairo-path=./src target "$1"
sed -i '1c%builtins output pedersen range_check ecdsa bitwise' src/validate.cairo
