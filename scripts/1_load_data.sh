if [[ ! -f usecase_data/sc_counts_reannotated_with_counts.h5ad ]]; then
  aws s3 cp \
    --no-sign-request \
    s3://openproblems-bio/public/neurips-2023-competition/sc_counts_reannotated_with_counts.h5ad \
    usecase_data/sc_counts_reannotated_with_counts.h5ad
fi
