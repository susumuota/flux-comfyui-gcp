#!/bin/bash

export PROJECT_ID="your-project-id"  # change to your project ID
export ZONE="us-central1-a"
export INSTANCE_NAME="instance-1"
# export MACHINE_TYPE="g2-standard-4"      # for NVIDIA L4 with 16GB RAM
# export MACHINE_TYPE="g2-custom-4-32768"  # for NVIDIA L4 with 32GB RAM
export MACHINE_TYPE="g2-custom-8-55296"  # for NVIDIA L4 with 54GB RAM
# export MACHINE_TYPE="n1-standard-4"      # for NVIDIA T4 with 15GB RAM
export SCOPES="default,storage-full"
export IMAGE_PROJECT="ubuntu-os-cloud"
export IMAGE_FAMILY="ubuntu-2204-lts"
export DISK_NAME="disk-1"
export DISK_SIZE="100GB"
export DISK_TYPE="pd-ssd"
export ACCELERATOR="nvidia-l4"        # for NVIDIA L4
# export ACCELERATOR="nvidia-tesla-t4"  # for NVIDIA T4
export PROVISIONING_MODEL="SPOT"      # or "STANDARD"
