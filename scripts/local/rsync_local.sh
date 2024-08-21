#!/bin/bash

# create a bucket before running this script
# gsutil mb -l "us-central1" -p "$PROJECT_ID" gs://flux-outputs-1

src="gs://flux-outputs-1/output"  # edit here
dst="output"
wait=60

mkdir -p "$dst"
while true ; do gsutil -m rsync -r "$src" "$dst" ; sleep $wait ; done
