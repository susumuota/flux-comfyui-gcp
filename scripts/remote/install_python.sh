#!/bin/bash

sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  aria2 \
  git \
  libgl1 \
  libglib2.0-0 \
  python-is-python3 \
  python3 \
  python3-pip \
  python3-venv \
  && sudo rm -rf /var/lib/apt/lists/*
