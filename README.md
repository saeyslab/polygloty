# polygloty

## Installation

For the best polyglot experience, we recommend using [Pixi](https://pixi.sh/latest/) to manage your development environment. Once setup and in a clean shell without any active Python (`deactivate`) or Conda environments (`conda deactivate`), you can install all dependencies with the following command:

```bash
pixi install
```

## Usage

To run the notebooks in this notebooks yourself, you can use VSCode or RStudio. For VSCode, select the kernel in the top right corner of the notebook. For RStudio, you have to start using the Pixi task runner:

```bash
pixi run rstudio
```

## Development

To install the development dependencies, you can use the following command:

```bash
pixi install --dev
```

To run the tests, you can use the following command:

```bash
pixi test
```

or 
    
```bash
pixi shell -e dev
pytest
``` 

To run the quarto notebooks in the `notebooks` directory, you can use the following command after installing quarto globally or via the dev environment:

```bash
quarto preview
```
