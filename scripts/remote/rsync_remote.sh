#!/bin/bash

# create a bucket before running this script
# gsutil mb -l "us-central1" -p "$PROJECT_ID" gs://flux-outputs-1

src="output"
dst="gs://flux-outputs-1/output"  # edit here
wait=60

cd ComfyUI || exit

mkdir -p "$src"
while true ; do gsutil -m rsync -r "$src" "$dst" ; sleep $wait ; done

cd ..
