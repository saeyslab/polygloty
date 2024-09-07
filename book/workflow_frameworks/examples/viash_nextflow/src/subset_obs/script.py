import anndata as ad

## VIASH START
par = {"input": "", "obs_column": "", "obs_values": [], "invert": False, "output": ""}
## VIASH END

print("Load data", flush=True)
adata = ad.read_h5ad(par["input"])

print(f"Format of input data: {adata}", flush=True)

print("Subset data", flush=True)
filt = adata.obs[par["obs_column"]]

# if filt is a list of booleans
assert (filt.dtype == bool) == (not par["obs_values"]), \
  f"If column '{par['obs_column']}' is boolean, 'obs_values' must be empty, and vice versa."

if filt.dtype != bool:
  # if filt is a list of strings
  filt = filt.isin(par["obs_values"])

if par["invert"]:
  filt = ~filt

adata = adata[filt].copy()

print(f"Format of output data: {adata}", flush=True)

print("Store to disk", flush=True)
adata.write_h5ad(par["output"], compression="gzip")
