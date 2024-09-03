#!/usr/bin/env Rscript

# Alternatively, you could use Pixi to install Conda packages from R and bioconda, but this way is more familiar to R users and support of bioconda for osx-arm64 is still in development.
# See https://github.com/bioconda/bioconda-recipes/issues/33333

# https://github.com/scverse/anndataR
install.packages("hdf5r", repos = "https://cloud.r-project.org/")
devtools::install_github("scverse/anndataR", dependencies = TRUE)

# for 'notebooks/usecase.qmd'
BiocManager::install("DESeq2")
