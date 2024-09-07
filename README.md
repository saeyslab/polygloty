# Polyglot programming for single-cell analysis <img src="assets/cover.svg" align ="right" alt="" width ="150"/>

This book is a collection of notebooks and explanations for the workshop on **Polyglot programming for single-cell analysis** given at the [scverse Conference 2024](https://scverse.org/conference2024). For more information, please visit the [workshop page](https://cfp.scverse.org/2024/talk/AWKXCB/).

## Installation

For the best polyglot experience, we recommend using [Pixi](https://pixi.sh/latest/) to manage your development environment. Once setup and in a clean shell without any active Python (`deactivate`) or Conda environments (`conda deactivate`), you can install all dependencies with the following command:

```bash
pixi i -e dev
```

Installation of the R dependencies in Pixi is more difficult, because Pixi does not support [post-link scripts](https://github.com/prefix-dev/pixi/issues/1573) and the bioconda channel for bioconductor packages does not yet support [osx-arm64](https://github.com/bioconda/bioconda-recipes/issues/33333).

To fully install the R dependencies used in the notebooks, use a script via the following command:

```bash
pixi r setup_R
```

## Usage

To run the notebooks in this notebooks yourself, you can use VSCode or RStudio. For VSCode, install the [Quarto extension in VSCode](https://quarto.org/docs/tools/vscode.html) to render the notebooks correctly. Click Run Cell and select the kernel `dev` located at the path `.pixi/envs/dev/bin/python`. For more information, see [this issue](https://github.com/prefix-dev/pixi/issues/411). For R, be sure to install the R extension and set the Rpath and Rterm in VSCode Settings to the correct path e.g. `${workspaceFolder}/.pixi/envs/default/bin/R`.

For RStudio, you have to [install RStudio globally](https://quarto.org/docs/tools/rstudio.html) and start using the Pixi task runner or make sure that `dev` environment installed in this project folder is used within RStudio.:

```bash
pixi r rstudio
```

## Development

For development, some common tasks are available via the Pixi task runner. If you want more control, you can start a development shell using `pixi shell -e dev`.

To run the tests in the test environment, you can use the following command:

```bash
pixi r pytest
```

To run a auto-reloading preview server of the workshop book, use the following to start quarto in the dev environment. If you instead use quarto globally, the jupyter python3 kernel will not point to the Pixi dev environment:

```bash
pixi r preview
```

Use the Render option in the Quarto extension in VSCode when editing the slides for an auto-reloading preview.

To render the slides correctly in the workshop book site using [embedio](https://github.com/coatless-quarto/embedio), use the following command to create the revealjs and pdf version of the slides. This requires Docker to be installed and running on your system:

```bash
pixi r render_slides
```

## renv

I'm currently experiencing issues with getting `pixi` to install `rpy2`. As a temporary workaround, I'm using `renv` to manage the R dependencies.

### First time setup

To install the R and Python dependencies, use the following command. Start a new R session with `R` or run within `RStudio`:

```R
install.packages("renv")
renv::restore()
```

On MacOS ARM, you will need [extra configuration](https://firas.io/posts/r_macos/) and patience to be able to build some of the packages.

### Adding new packages

If you want to install a new R package, use the following command:

```R
renv::install("anndata")
```

If you want to install a new Python package, use the following command:

```bash
reticulate::py_install(c("rich>=13.7,<13.8", "anndata>=0.10.8,<0.11", "numpy>=1.24,<2", "scanpy>=1.10,<2", "mudata>=0.3,<0.4", "rpy2>=3.4,<4", "jupyter"))
```

After installing a new package, use the following command to update the `renv.lock` file:

```R
renv::snapshot()
```

### Using the environment

To use the environment, use the following command:

```bash
# ensure that jupyter can also use the renv environment
source renv/python/virtualenvs/renv-python-3.12/bin/activate
quarto preview
```

Or to render the slides:

```bash
source renv/python/virtualenvs/renv-python-3.12/bin/activate
quarto render
```

## Pixi and Docker

Environment creation support for Pixi on Windows and MacOS ARM is currently limited for R packages. Only Linux and Docker are supported for the full pipeline.

### Linux

To run the pipeline on Linux, use the following command:

```bash
pixi run pipeline
```

### Docker

To run the pipeline with Docker, use the following command. The image is ~5GB and the pipeline can require a lot of working memory ~20GB, so make sure to increase the RAM allocated to Docker in your settings. Note that the usecase_data/ and scripts/ folders are mounted to the Docker container, so you can edit the scripts and access the data.

```bash
docker pull berombau/polygloty-docker:latest
docker run -it -v $(pwd)/usecase_data:/app/usecase_data -v $(pwd)/scripts:/app/scripts berombau/polygloty-docker:latest pixi run pipeline
```

### Extra: building the Docker image yourself

To edit and build the Docker image yourself, use can use the following command.:

```bash
docker build -t polygloty-docker .
docker run -it -v $(pwd)/usecase_data:/app/usecase_data -v $(pwd)/scripts:/app/scripts polygloty-docker pixi run pipeline
```

To publish it to Docker Hub, use the following command:

```bash
docker login
docker buildx build --push --platform linux/amd64,linux/arm64 --tag berombau/polygloty-docker:latest .
```

More info on Pixi and Docker can be found [here](https://github.com/prefix-dev/pixi-docker).
