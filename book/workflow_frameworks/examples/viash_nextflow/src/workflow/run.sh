#!/bin/bash

nextflow run \
  target/nextflow/workflow/main.nf \
  -with-docker \
  --id dataset \
  --input s3://openproblems-bio/public/neurips-2023-competition/sc_counts_reannotated_with_counts.h5ad \
  --contrast 'sm_name;Belinostat;Dimethyl Sulfoxide' \
  --design_formula '~ sm_name + plate_name' \
  --publish_dir output