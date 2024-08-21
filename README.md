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


## Usage

### Clone this repository

On the local machine, run the following commands.

```bash
git clone https://github.com/susumuota/flux-comfyui-gcp.git
cd flux-comfyui-gcp
```

### Set environment variables

Edit [`scripts/local/set_envs.sh`](scripts/local/set_envs.sh) and set the `PROJECT_ID` to your project ID.

```bash
export PROJECT_ID="your-project-id"  # change to your project ID
```

Then, run the following command.

```bash
source scripts/local/set_envs.sh
```

### Create a bucket to copy images from the remote instance to the local machine

To transfer images from the remote instance to the local machine, create a GCS bucket.
`flux-outputs-1` is just an example. You can use any name.

```bash
gsutil mb -l "us-central1" -p "$PROJECT_ID" gs://flux-outputs-1
```

Edit [`scripts/local/rsync_local.sh`](scripts/local/rsync_local.sh) and [`scripts/remote/rsync_remote.sh`](scripts/remote/rsync_remote.sh) to replace `flux-outputs-1` with your bucket name.

### Create an instance

- https://cloud.google.com/compute/docs/instances/create-start-instance

```bash
bash scripts/local/create_gcp_instance.sh
```

### SSH into the instance

```bash
bash scripts/local/ssh_gcp_instance.sh
```

### Setup the instance

On the **remote instance** (not the local machine), run the following commands.

```bash
git clone https://github.com/susumuota/flux-comfyui-gcp.git

# create dot files for several commands. customize them if necessary.
bash flux-comfyui-gcp/scripts/remote/create_dot_files.sh

# this takes a few minutes
# if you want to reboot just after the installation, run the following command instead.
bash flux-comfyui-gcp/scripts/remote/install_cuda_drivers.sh && sudo reboot
```

Your SSH connection will be lost. Wait a few minutes and then ssh into the instance again.
On the local machine, run the following command.

```bash
bash scripts/local/ssh_gcp_instance.sh
```

On the remote instance, run the following commands.
`tmux` is optional, but I strongly recommend using it to recover the session if the connection is lost.

```bash
tmux
bash flux-comfyui-gcp/scripts/remote/install_python.sh
python -V  # Python 3.10.12
```

If the connection is lost, ssh into the instance again and run the following commands to recover the session.

```bash
bash scripts/local/ssh_gcp_instance.sh
tmux a  # to attach the session
```

### Install ComfyUI

```bash
bash flux-comfyui-gcp/scripts/remote/install_comfyui.sh
```

### Download Flux.1 files

```bash
bash flux-comfyui-gcp/scripts/remote/download_flux.sh
```

### Run ComfyUI

```bash
bash flux-comfyui-gcp/scripts/remote/run_comfyui.sh
```

### Rsync the images

On the remote instance, run the following command.

```bash
bash flux-comfyui-gcp/scripts/remote/rsync_remote.sh
```

On the local machine, run the following command.

```bash
bash scripts/local/rsync_local.sh
```


### Delete the instance

```bash
bash scripts/local/delete_gcp_instance.sh
```

Press `y` to confirm the deletion.

### Delete the bucket

```bash
gsutil rm -r gs://flux-outputs-1
```

### Delete the project

- https://cloud.google.com/resource-manager/docs/creating-managing-projects#shutting_down_projects

```bash
gcloud projects delete "$PROJECT_ID"
```
