import sys
import json
import os

DEFAULT = "src/stark_verifier/parameters/default_parameters.json"
CAIRO_OUTPUT = "src/stark_verifier/parameters/parameters.cairo"

def main():

    # Delete previous
    if (os.path.exists(CAIRO_OUTPUT)):
        os.remove(CAIRO_OUTPUT)

    # Grab optional arguments
    args = sys.argv[1:]

    # Make sure there're maximum 1 argument
    assert len(args) <= 1, f"pass maximum 1 optional user-defined parameters.json"

    try:
        parameters = json.load(open(DEFAULT, 'r'))
    except IOError:
        print(f"ERROR: Couldn't find {DEFAULT}")
        return

    if (len(args) == 1):
        parameters.update(json.load(open(args[0], 'r')))

    f = open(CAIRO_OUTPUT, 'w')
    for key, value in parameters.items():
        f.write(f"const {key} = {value};\n")
    
    f.close()

if __name__ == "__main__":
    main()