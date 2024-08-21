#!/bin/bash

# you must run `source scripts/local/set_envs.sh` before running this script

gcloud compute instances delete "$INSTANCE_NAME" --project="$PROJECT_ID" --zone="$ZONE"

gcloud compute instances list --project="$PROJECT_ID"
