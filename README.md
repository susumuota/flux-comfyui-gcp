# flux-comfyui-gcp

How to generate images with Flux.1 using ComfyUI on GCP.

## Prerequisites

### Install gcloud CLI

- https://cloud.google.com/sdk/docs/install

### Create a project

- https://cloud.google.com/resource-manager/docs/creating-managing-projects#creating_a_project

Set the project ID to the `PROJECT_ID` in [`scripts/local/set_envs.sh`](scripts/local/set_envs.sh).

### Enable billing

- https://cloud.google.com/billing/docs/how-to/modify-project#how-to-enable-billing

### Increase GPU quotas

- https://cloud.google.com/compute/resource-usage#gpu_quota

Increase the GPU quotas. e.g. increase `NVIDIA_L4_GPUS` and `PREEMPTIBLE_NVIDIA_L4_GPUS` at region `us-central1` to 1.

## Usage

### Clone this repository

On the local machine, run the following commands.

```bash
git clone https://github.com/susumuota/flux-comfyui-gcp.git
```

### Set environment variables

Edit [`scripts/local/set_envs.sh`](scripts/local/set_envs.sh) and set the `PROJECT_ID` to your project ID.

```bash
export PROJECT_ID="your-project-id"  # change to your project ID
```

Select the provisioning model. `SPOT` is cheaper but may be terminated unexpectedly. `STANDARD` is more stable but more expensive.

```bash
export PROVISIONING_MODEL="SPOT"      # or "STANDARD"
```

Select the machine type. I recommend to start with `g2-custom-8-55296` for NVIDIA L4 with 54GB RAM, then reduce the resources according to your usage.

```bash
# export MACHINE_TYPE="g2-standard-4"      # for NVIDIA L4 with 16GB RAM
# export MACHINE_TYPE="g2-custom-4-32768"  # for NVIDIA L4 with 32GB RAM
export MACHINE_TYPE="g2-custom-8-55296"  # for NVIDIA L4 with 54GB RAM
# export MACHINE_TYPE="n1-standard-4"      # for NVIDIA T4 with 15GB RAM
```

<img alt="cost" src="https://github.com/user-attachments/assets/09b0aee0-37d8-47d9-8b2b-cd0431ef494b" width="600">

Then, run the following command to set the environment variables.

```bash
source flux-comfyui-gcp/scripts/local/set_envs.sh
```

### Create a bucket to copy images from the remote instance to the local machine

You can skip this step if you already have a bucket.

To transfer images from the remote instance to the local machine, create a GCS bucket.
`flux-outputs-1` is just an example. You can use any name.

```bash
gsutil mb -l "us-central1" -p "$PROJECT_ID" gs://flux-outputs-1
```

Edit [`scripts/local/rsync_local.sh`](scripts/local/rsync_local.sh) and [`scripts/remote/rsync_remote.sh`](scripts/remote/rsync_remote.sh) to replace `flux-outputs-1` with your bucket name.

```bash
dst="gs://flux-outputs-1/output"  # edit here
```

### Create an instance

- https://cloud.google.com/compute/docs/instances/create-start-instance

Confirm the contents of [`scripts/local/create_gcp_instance.sh`](scripts/local/create_gcp_instance.sh) and then run the following command to create an instance.

```bash
bash flux-comfyui-gcp/scripts/local/create_gcp_instance.sh
```

### SSH into the instance

Confirm the contents of [`scripts/local/ssh_gcp_instance.sh`](scripts/local/ssh_gcp_instance.sh) and then run the following command to ssh into the instance with port forwarding.

```bash
bash flux-comfyui-gcp/scripts/local/ssh_gcp_instance.sh
```

### Setup the instance

Confirm the contents of [`scripts/remote/create_dot_files.sh`](scripts/remote/create_dot_files.sh), [`scripts/remote/create_swap.sh`](scripts/remote/create_swap.sh) and [`scripts/remote/install_cuda_drivers.sh`](scripts/remote/install_cuda_drivers.sh).

On the **remote instance** (not the local machine), run the following commands.

```bash
git clone https://github.com/susumuota/flux-comfyui-gcp.git

# create dot files for several commands. customize them if necessary.
bash flux-comfyui-gcp/scripts/remote/create_dot_files.sh

# create a swap file. adjust the size `32g` if necessary.
bash flux-comfyui-gcp/scripts/remote/create_swap.sh

# install CUDA drivers. this takes a few minutes.
# if you want to reboot just after the installation, append "&& sudo reboot" to the command.
bash flux-comfyui-gcp/scripts/remote/install_cuda_drivers.sh && sudo reboot
```

Your SSH connection will be lost after the reboot.
Wait for a few minutes and then ssh into the instance again.
On the local machine, run the following command.

```bash
bash flux-comfyui-gcp/scripts/local/ssh_gcp_instance.sh
```

Confirm the contents of [`scripts/remote/install_python.sh`](scripts/remote/install_python.sh).

On the remote instance, run the following commands.

```bash
bash flux-comfyui-gcp/scripts/remote/install_python.sh
python -V  # Python 3.10.12
```

### Optional: Use tmux

I strongly recommend using `tmux` to recover the session if the connection is accidentally lost.

```bash
tmux
```

If the connection is lost, ssh into the instance again and run `tmux a` to recover the previous session.

```bash
bash flux-comfyui-gcp/scripts/local/ssh_gcp_instance.sh
tmux a  # to attach the session
```

### Install ComfyUI

Confirm the contents of [`scripts/remote/install_comfyui.sh`](scripts/remote/install_comfyui.sh). This script installs ComfyUI and some custom nodes. If you want to change CUDA version or other settings, edit it.

```bash
bash flux-comfyui-gcp/scripts/remote/install_comfyui.sh
```

### Download Flux.1 files

Confirm the contents of [`scripts/remote/download_flux.sh`](scripts/remote/download_flux.sh). This script downloads the Flux.1 files. Edit it if necessary.

```bash
bash flux-comfyui-gcp/scripts/remote/download_flux.sh
```

### Optional: Download the original `flux1-dev.safetensors`

If you want to download original `flux1-dev.safetensors`, it needs to be authenticated to download.

You have to accept the conditions to access its files and the contents.

- https://huggingface.co/black-forest-labs/FLUX.1-dev

Then, generate a read-only token for `huggingface-cli login`.

- https://huggingface.co/settings/tokens

Now, run the following commands on the remote instance.

```bash
cd ComfyUI
source env/bin/activate

pip install hf_transfer
pip install "huggingface_hub[hf_transfer]"

huggingface-cli login   # enter the token generated above
huggingface-cli whoami  # confirm the login

# this command should work without authentication error
HF_HUB_ENABLE_HF_TRANSFER=1 huggingface-cli download black-forest-labs/FLUX.1-dev flux1-dev.safetensors --repo-type=model --local-dir="models/unet"
rm -rf models/unet/.cache

deactivate
cd ..
```

### Run ComfyUI

Confirm the contents of [`scripts/remote/run_comfyui.sh`](scripts/remote/run_comfyui.sh).

```bash
bash flux-comfyui-gcp/scripts/remote/run_comfyui.sh
```

Now, open a web browser on the local machine and access [`http://localhost:8188/`](http://localhost:8188/).

### Rsync the images

On the remote instance, open a new tmux window by pressing `Ctrl-j` and then `c`. (default key bindings is `Ctrl-b` instead of `Ctrl-j`). Or you can open a new terminal on the local machine and ssh into the remote instance again.

Confirm the contents of [`scripts/remote/rsync_remote.sh`](scripts/remote/rsync_remote.sh) and [`scripts/local/rsync_local.sh`](scripts/local/rsync_local.sh). This script periodically synchronizes the images from the remote instance to the local machine.

On the remote instance, run the following command.

```bash
# generated images will be copied to from remote "output" directory to "gs://flux-outputs-1" bucket
bash flux-comfyui-gcp/scripts/remote/rsync_remote.sh
```

On the local machine, run the following command.

```bash
# generated images will be copied from "gs://flux-outputs-1" bucket to local "output" directory
bash flux-comfyui-gcp/scripts/local/rsync_local.sh
```

### Delete the instance

If you finish using the instance, you must delete it to avoid unnecessary charges.

Confirm the contents of [`scripts/local/delete_gcp_instance.sh`](scripts/local/delete_gcp_instance.sh) and then run the following command.

```bash
bash flux-comfyui-gcp/scripts/local/delete_gcp_instance.sh
```

Press `y` to confirm the deletion.

### Optional: Delete the bucket

If you are sure that you don't need the bucket anymore, you can delete it.

```bash
gsutil rm -r gs://flux-outputs-1
```

### Optional: Delete the project

If you are sure that you don't need the project anymore, you can delete it.

- https://cloud.google.com/resource-manager/docs/creating-managing-projects#shutting_down_projects

```bash
gcloud projects delete "$PROJECT_ID"
```

That's all. Enjoy Flux.1 with ComfyUI on GCP!
