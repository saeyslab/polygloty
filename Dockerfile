FROM ghcr.io/prefix-dev/pixi:0.29.0

# copy source code, pixi.toml and pixi.lock to the container
COPY . /app
WORKDIR /app

# run some compilation / build task (if needed)
RUN pixi install -a
RUN pixi run -e rverse bash book/disk_based/scripts/setup.sh

CMD ["pixi", "run", "pipeline"]
