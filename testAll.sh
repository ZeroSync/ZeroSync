#!/bin/bash

pip install .
zerosync -c validate-batch 1-3
pytest
cd cairo
./testCairo.sh
cd ..
