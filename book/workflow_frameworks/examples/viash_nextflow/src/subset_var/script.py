import anndata as ad

## VIASH START
par = {"input": "", "var_column": "", "var_values": [], "invert": False, "output": ""}
## VIASH END

print("Load data", flush=True)
adata = ad.read_h5ad(par["input"])

print(f"Format of input data: {adata}", flush=True)

print("Subset data", flush=True)
filt = adata.var[par["var_column"]]

# if filt is a list of booleans
assert (filt.dtype == bool) == (not par["var_values"]), \
  f"If column '{par['var_column']}' is boolean, 'var_values' must be empty, and vice versa."

if filt.dtype != bool:
  # if filt is a list of strings
  filt = filt.isin(par["var_values"])

if par["invert"]:
  filt = ~filt

adata = adata[:, filt].copy()

print(f"Format of output data: {adata}", flush=True)

print("Store to disk", flush=True)
adata.write_h5ad(par["output"], compression="gzip")
