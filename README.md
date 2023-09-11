# MatFlow-DAMASK-parse

This repository hosts the dockerfile to create a container image based on micromamba, with an environment with matflow and damask-parse installed.

## Usage

The environment is activated automatically, so you can directly run the container with
```
docker run --rm ghcr.io/hpcflow/matflow-damask-parse:latest matflow --help
```

### Interactive

If you want to run an interactive container use
```
docker run --rm -it ghcr.io/hpcflow/matflow-damask-parse:latest bash
```
This should place you in `/wd` inside the container, where you can now run `matflow --help`, or import `damask` or `damask_parse` in python.

### File transfer between the container and host

If you need to access files from your host machine in the container, or get resulting files from the container on your host machine, you can use a volume mount by adding the flag `-v $PWD/wd:/wd` to the command.

This will map the `./wd` directory in your host machine to `/wd` in the container, which is where the command runs. Any outputs generated in this directory will also be available in the host machine (`./wd`).

For example,

```
docker run --rm -v $PWD/wd:/wd ghcr.io/hpcflow/matflow-damask-parse:latest python -c "from pathlib import Path; Path('greetings.txt').write_text('Hello from the matflow-damask-parse container.');"
```

should create a `greetings.txt` file in your host machine.

**WARNING**: any files that you modify in the container directory `/wd` will also be modified in the host system's `./wd`.


## Build

The easiest way to build and deploy the image is through the [build-test-push](https://github.com/hpcflow/matflow-damask-parse-image/actions/workflows/build-test-push.yml) action, which can be manually triggered.

The image can be built and tested without pushing to ghcr.io by setting both inputs to false.

### Building locally

Preferably build new images with the `--no-cache` option:
```
docker build --no-cache -t ghcr.io/hpcflow/matflow-damask-parse:latest .
```
Once the build is finished, push to ghcr with
```
docker push ghcr.io/hpcflow/matflow-damask-parse:latest
```
Rmember to also push a version tagged with the damask and matflow version, e.g.:
```
docker build -t ghcr.io/hpcflow/matflow-damask-parse:d3.0.0a7_m0.3.0a31 .
docker push ghcr.io/hpcflow/matflow-damask-parse:d3.0.0a7_m0.3.0a31
```

## Usage with Apptainer/Singularity

See the apptainer folder and readme [here](https://github.com/hpcflow/matflow-damask-parse-image/tree/main/apptainer).
