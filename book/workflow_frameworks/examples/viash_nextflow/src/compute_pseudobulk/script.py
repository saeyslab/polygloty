import anndata as ad
import pandas as pd
import numpy as np

## VIASH START
par = {"input": "", "obs_column_index": "", "obs_column_values": [], "output": ""}
## VIASH END

print("Load data", flush=True)
adata = ad.read_h5ad(par["input"])

print(f"Format of input data: {adata}", flush=True)
assert par["obs_column_index"] in adata.obs.columns, f"Column '{par['obs_column']}' not found in obs."
for col in par["obs_column_values"]:
  assert col in adata.obs.columns, f"Column '{col}' not found in obs."

print("Compute pseudobulk", flush=True)
X = adata.X
if not isinstance(X, np.ndarray):
  X = X.toarray()
combined = pd.DataFrame(
  X,
  index=adata.obs[par["obs_column_index"]],
)
combined.columns = adata.var_names
pb_X = combined.groupby(level=0).sum()

print("Construct obs for pseudobulk")
pb_obs = adata.obs[par["obs_column_values"]].copy()
pb_obs.index = adata.obs[par["obs_column_index"]]
pb_obs = pb_obs.drop_duplicates()

print("Create AnnData object")
pb_adata = ad.AnnData(
  X=pb_X.loc[pb_obs.index].values,
  obs=pb_obs,
  var=adata.var,
)

print("Store to disk")
pb_adata.write_h5ad(par["output"], compression="gzip")
