#!/bin/bash

cat /proc/swaps

sudo fallocate -l 32g /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

cat /proc/swaps

sudo cp -p /etc/fstab /etc/fstab.bak
cat << EOF | sudo tee -a /etc/fstab
/swapfile swap swap defaults 0 0
EOF
