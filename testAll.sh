#!/bin/bash

pip install .
sibd -c validate-batch 1-3
pytest
cd cairo
./testCairo.sh
cd ..
