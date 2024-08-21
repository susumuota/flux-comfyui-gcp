#!/bin/bash

# https://github.com/comfyanonymous/ComfyUI#manual-install-windows-linux
git clone https://github.com/comfyanonymous/ComfyUI.git
cd ComfyUI || exit

python -m venv env
# shellcheck source=/dev/null
source env/bin/activate

# https://github.com/comfyanonymous/ComfyUI#nvidia
# CUDA 12.1
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
# CUDA 12.4
# pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124
# CPU
# pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# https://github.com/comfyanonymous/ComfyUI#dependencies
pip install -r requirements.txt

# custom nodes
cd custom_nodes || exit

# https://github.com/ltdrdata/ComfyUI-Manager#installation
git clone https://github.com/ltdrdata/ComfyUI-Manager.git

# https://github.com/ltdrdata/ComfyUI-Impact-Pack#installation
git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack.git

# https://github.com/ssitu/ComfyUI_UltimateSDUpscale#installation
git clone https://github.com/ssitu/ComfyUI_UltimateSDUpscale --recursive

# https://github.com/city96/ComfyUI-GGUF#installation
git clone https://github.com/city96/ComfyUI-GGUF
pip install -r ComfyUI-GGUF/requirements.txt

cd ..
