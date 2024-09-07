#!/bin/bash

# Run the executable
"$meta_executable" \
  --url s3://openproblems-bio/public/neurips-2023-competition/moa_annotations.csv \
  --output moa_annotations.csv

# Check if the output file exists
if [[ ! -f moa_annotations.csv ]]; then
  echo "File not found!"
  exit 1
fi

# Check if the output file has the correct MD5 sum
if [[ "$(md5sum moa_annotations.csv | cut -d ' ' -f 1)" != "80ebe44ce6b8d73f31dbc653787089f9" ]]; then
  echo "MD5 sum does not match!"
  exit 1
fi

echo "All tests passed!"