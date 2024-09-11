cat("Loading libraries...\n")
library(anndata)
library(dplyr, warn.conflicts = FALSE)

cat("Reading data...\n")
pb_adata <- read_h5ad("usecase/data/pseudobulk.h5ad")

# Select small molecule and control:
sm_name <- "Belinostat"
control_name <- "Dimethyl Sulfoxide"

cat("Create DESeq dataset\n")
# transform counts matrix
count_data <- t(pb_adata$X)
storage.mode(count_data) <- "integer"

# create dataset
dds <- DESeq2::DESeqDataSetFromMatrix(
  countData = count_data,
  colData = pb_adata$obs,
  design = ~ sm_name + plate_name,
)

cat("Run DESeq2\n")
dds <- DESeq2::DESeq(dds)

# Get results:
res <- DESeq2::results(dds, contrast=c("sm_name", sm_name, control_name)) |>
  as.data.frame()

# Preview results:
res |>
  arrange(padj) |>
  head(10)

# Write to disk:
write.csv(res, "usecase/data/de_contrasts.csv")