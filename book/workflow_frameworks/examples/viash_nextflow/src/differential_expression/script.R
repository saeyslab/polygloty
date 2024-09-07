library(anndata)
requireNamespace("DESeq2", quietly = TRUE)

## VIASH START
par <- list(input = "", contrast = c(), design_formula = "", output = "")
## VIASH END

cat("Reading data\n")
adata <- read_h5ad(par$input)

cat("Parse formula\n")
formula <- as.formula(par$design_formula)

cat("Create DESeq dataset\n")
# transform counts matrix
count_data <- t(as.matrix(adata$X))
storage.mode(count_data) <- "integer"

# create dataset
dds <- DESeq2::DESeqDataSetFromMatrix(
  countData = count_data,
  colData = adata$obs,
  design = formula
)

cat("Run DESeq2\n")
dds <- DESeq2::DESeq(dds)

res <- DESeq2::results(dds, contrast = par$contrast) |>
  as.data.frame()

cat("Write to disk\n")
contrast_names <- gsub(" ", "_", par$contrast)
contrast_names <- gsub("[^[:alnum:]]", "_", contrast_names)
contrast_names <- gsub("__", "_", contrast_names)
contrast_names <- tolower(contrast_names)

varm_name <- paste0("de_", paste(contrast_names, collapse = "_"))
adata$varm[[varm_name]] <- res

# Save adata
zzz <- adata$write_h5ad(par$output, compression = "gzip")
