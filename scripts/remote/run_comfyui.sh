#!/bin/bash

cd ComfyUI || exit

python -m venv env
# shellcheck source=/dev/null
source env/bin/activate

# CUDA
python main.py

# CPU
# python main.py --cpu

cd ..
