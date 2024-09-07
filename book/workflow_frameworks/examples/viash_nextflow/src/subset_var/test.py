import sys
import anndata as ad
import pytest
import numpy as np

def test_subset_var(run_component, tmp_path):
  input_path = tmp_path / "input.h5ad"
  output_path = tmp_path / "output.h5ad"

  # create data
  adata_in = ad.AnnData(
    X=np.random.rand(4, 2),
    obs={"cell_type": ["A", "B", "C", "D"]},
    var={"highly_variable": [True, False]},
  )

  adata_in.write_h5ad(input_path)

  # run component
  run_component([
    "--input", str(input_path),
    "--var_column", "highly_variable",
    "--output", str(output_path),
  ])

  # load output
  adata_out = ad.read_h5ad(output_path)

  # check output
  assert adata_out.X.shape == (4, 1)
  assert adata_out.obs["cell_type"].tolist() == ["A", "B", "C", "D"]
  assert adata_out.var["highly_variable"].tolist() == [True]


if __name__ == "__main__":
  sys.exit(pytest.main([__file__]))
