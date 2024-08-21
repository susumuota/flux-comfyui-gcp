#!/bin/bash

# you must run `source scripts/local/set_envs.sh` before running this script

gcloud compute instances create "$INSTANCE_NAME" \
  --project="$PROJECT_ID" \
  --zone="$ZONE" \
  --machine-type="$MACHINE_TYPE" \
  --scopes="$SCOPES" \
  --create-disk=boot=yes,image-project="$IMAGE_PROJECT",image-family="$IMAGE_FAMILY",name="$DISK_NAME",size="$DISK_SIZE",type="$DISK_TYPE" \
  --accelerator=count=1,type="$ACCELERATOR" \
  --provisioning-model="$PROVISIONING_MODEL"
