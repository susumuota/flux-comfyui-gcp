#!/bin/bash

# you must run `source scripts/local/set_envs.sh` before running this script

gcloud compute instances list --project="$PROJECT_ID"
