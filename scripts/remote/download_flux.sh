#!/bin/bash

cd ComfyUI || exit

# https://comfyanonymous.github.io/ComfyUI_examples/flux/
# https://comfyui-wiki.com/tutorial/advanced/flux1-comfyui-guide-workflow-and-examples#download-comfyui-flux_text_encoders-clip-models
aria2c -x 5 "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors" -d "models/clip" -o "t5xxl_fp16.safetensors"
aria2c -x 5 "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp8_e4m3fn.safetensors" -d "models/clip" -o "t5xxl_fp8_e4m3fn.safetensors"
aria2c -x 5 "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors" -d "models/clip" -o "clip_l.safetensors"
aria2c -x 5 "https://huggingface.co/black-forest-labs/FLUX.1-schnell/resolve/main/ae.safetensors" -d "models/vae" -o "ae.safetensors"
aria2c -x 5 "https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/flux1-dev.safetensors" -d "models/unet" -o "flux1-dev.safetensors"
# aria2c -x 5 "https://huggingface.co/black-forest-labs/FLUX.1-schnell/resolve/main/flux1-schnell.safetensors" -d "models/unet" -o "flux1-schnell.safetensors"
# aria2c -x 5 "https://huggingface.co/Comfy-Org/flux1-schnell/resolve/main/flux1-schnell-fp8.safetensors" -d "models/checkpoints" -o "flux1-schnell-fp8.safetensors"

# https://github.com/city96/ComfyUI-GGUF#usage
aria2c -x 5 "https://huggingface.co/city96/FLUX.1-dev-gguf/resolve/main/flux1-dev-Q6_K.gguf" -d "models/unet" -o "flux1-dev-Q6_K.gguf"
# aria2c -x 5 "https://huggingface.co/city96/FLUX.1-schnell-gguf/resolve/main/flux1-schnell-Q6_K.gguf" -d "models/unet" -o "flux1-schnell-Q6_K.gguf"

cd ..
