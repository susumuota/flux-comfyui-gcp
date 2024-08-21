#!/bin/bash

# you must run `source scripts/local/set_envs.sh` before running this script

gcloud compute ssh --zone="$ZONE" "$INSTANCE_NAME" --project="$PROJECT_ID" -- -L 8188:localhost:8188
