# The dataset is stored in an AnnData object, which can be loaded in Python as follows:
import anndata as ad

print("Load data")
adata = ad.read_h5ad("usecase_data/sc_counts_reannotated_with_counts.h5ad")

sm_name = "Belinostat"
control_name = "Dimethyl Sulfoxide"
cell_type = "T cells"

adata = adata[
  adata.obs["sm_name"].isin([sm_name, control_name]) &
  adata.obs["cell_type"].isin([cell_type]),
].copy()

# We will also subset the genes to the top 2000 most variable genes.

adata = adata[:, adata.var["highly_variable"]].copy()

print("Compute pseudobulk")
# Combine data in a single data frame and compute pseudobulk
import pandas as pd

combined = pd.DataFrame(
  adata.X.toarray(),
  index=adata.obs["plate_well_celltype_reannotated"],
)
combined.columns = adata.var_names
pb_X = combined.groupby(level=0).sum()

print("Construct obs for pseudobulk")

# Use 'plate_well_celltype_reannotated' as index and make sure to retain the columns 'sm_name', 'cell_type', and 'plate_name':

pb_obs = adata.obs[["sm_name", "cell_type", "plate_name", "well"]].copy()
pb_obs.index = adata.obs["plate_well_celltype_reannotated"]
pb_obs = pb_obs.drop_duplicates()

print("Create AnnData object")
pb_adata = ad.AnnData(
  X=pb_X.loc[pb_obs.index].values,
  obs=pb_obs,
  var=adata.var,
)

print("Store to disk")
pb_adata.write_h5ad("usecase_data/pseudobulk.h5ad")
