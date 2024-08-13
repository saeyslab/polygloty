# Polyglot programming for single-cell analysis <img src="assets/cover.svg" align ="right" alt="" width ="150"/>

This book is a collection of notebooks and explanations for the workshop on **Polyglot programming for single-cell analysis** given at the [scverse Conference 2024](https://scverse.org/conference2024). For more information, please visit the [workshop page](https://cfp.scverse.org/2024/talk/AWKXCB/).

## Installation

For the best polyglot experience, we recommend using [Pixi](https://pixi.sh/latest/) to manage your development environment. Once setup and in a clean shell without any active Python (`deactivate`) or Conda environments (`conda deactivate`), you can install all dependencies with the following command:

```bash
pixi i -e dev
```

## Usage

To run the notebooks in this notebooks yourself, you can use VSCode or RStudio. For VSCode, install the [Quarto extension in VSCode](https://quarto.org/docs/tools/vscode.html) to render the notebooks correctly. Click Run Cell and select the kernel `dev` located at the path `.pixi/envs/dev/bin/python`.

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
