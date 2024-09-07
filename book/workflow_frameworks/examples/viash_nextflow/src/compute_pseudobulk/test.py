import sys
import anndata as ad
import pytest
import numpy as np

def test_subset_var(run_component, tmp_path):
  input_path = tmp_path / "input.h5ad"
  output_path = tmp_path / "output.h5ad"

  # create data
  adata_in = ad.AnnData(
    X=np.array([[1, 2], [3, 4], [5, 6], [7, 8]]),
    obs={
      "cell_type": ["A", "A", "B", "B"],
      "time": [1, 2, 1, 2],
      "condition": ["ctrl", "ctrl", "trt", "trt"],
    },
    var={"highly_variable": [True, False]},
  )

  adata_in.write_h5ad(input_path)

  # run component
  run_component([
    "--input", str(input_path),
    "--obs_column_index", "cell_type",
    "--obs_column_values", "condition",
    "--output", str(output_path),
  ])

  # load output
  adata_out = ad.read_h5ad(output_path)

  # check output
  assert adata_out.X.shape == (2, 2)
  assert np.all(adata_out.X == np.array([[4, 6], [12, 14]]))
  assert adata_out.obs.index.tolist() == ["A", "B"]
  assert adata_out.obs["condition"].tolist() == ["ctrl", "trt"]
  assert adata_out.var["highly_variable"].tolist() == [True, False]


if __name__ == "__main__":
  sys.exit(pytest.main([__file__]))
