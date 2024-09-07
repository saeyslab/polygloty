#!/bin/bash

aws s3 cp \
  --no-sign-request \
  "$par_url" \
  "$par_output"
