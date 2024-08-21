#!/bin/bash

# https://docs.nvidia.com/datacenter/tesla/tesla-installation-notes/index.html#ubuntu-lts

lspci | grep -i nvidia

sudo apt-get install linux-headers-"$(uname -r)"

sudo apt-key del 7fa2af80

distro="ubuntu2204"
arch="x86_64"
wget https://developer.download.nvidia.com/compute/cuda/repos/$distro/$arch/cuda-keyring_1.1-1_all.deb

sudo dpkg -i cuda-keyring_1.1-1_all.deb

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install cuda-drivers
# sudo DEBIAN_FRONTEND=noninteractive apt-get -y install cuda-toolkit
# sudo DEBIAN_FRONTEND=noninteractive apt-get -y install cuda

echo "run 'sudo reboot' to enable the driver"
