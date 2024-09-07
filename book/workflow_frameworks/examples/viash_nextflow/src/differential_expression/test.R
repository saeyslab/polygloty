library(anndata)

cat("Create input data\n")
X <- matrix(runif(100, 10, 100), nrow = 10, ncol = 10)
for (i in 1:10) {
  X[1:5, i] <- X[1:5, i] + i * 10
}
adata_in <- AnnData(
  X = X,
  obs = data.frame(
    row.names = paste0("cell", 1:10),
    sm_name = rep(c("Belinostat", "Dimethyl Sulfoxide"), each = 5),
    plate_name = rep(c("plate1", "plate2"), times = 5)
  ),
  var = data.frame(
    row.names = paste0("gene", 1:10)
  )
)

cat("Write input data to file\n")
input_path <- "input.h5ad"
output_path <- "output.h5ad"
zzz <- adata_in$write_h5ad(input_path)

cat("Run component\n")
zzz <- processx::run(
  command = meta$executable,
  args = c(
    "--input", input_path,
    "--contrast", "sm_name;Dimethyl Sulfoxide;Belinostat",
    "--design_formula", "~ sm_name + plate_name",
    "--output", output_path
  ),
  error_on_status = TRUE,
  echo = TRUE
)

cat("Read output data\n")
adata_out <- read_h5ad(output_path)

cat("Preview output data\n")
print(adata_out)

cat("Check DE results:\n")
de_out <- adata_out$varm$de_sm_name_dimethyl_sulfoxide_belinostat
if (is.null(de_out)) {
  stop("No DE results found")
}

print(de_out)

expected_colnames <- c("baseMean", "log2FoldChange", "lfcSE", "stat", "pvalue", "padj")
if (!all(colnames(de_out) == expected_colnames)) {
  stop(paste0(
    "Column names do not match.\n",
    "Expected: ", paste(expected_colnames, collapse = ", "), "\n",
    "Actual: ", paste(colnames(de_out), collapse = ", ")
  ))
}

cat("Done\n")