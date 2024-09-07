print("Setting up the environment...")

if (!require("DESeq2", quietly = TRUE)) {
    BiocManager::install(c("GenomeInfoDbData", "DESeq2"))
    reticulate::install_miniconda()
    anndata::install_anndata()
}
