# MatFlow-DAMASK-parse

This repository hosts the dockerfile to create a container image based on micromamba, with an environment with matflow and damask-parse installed.

## Usage

The environment is activated automatically, so you can directly run the container with
```
docker run ghcr.io/hpcflow/matflow-damask-parse:latest matflow --help
```

### Interactive

If you want to run an interactive container use
```
docker run -it ghcr.io/hpcflow/matflow-damask-parse:latest bash
```
This should place you in `/tmp` inside the container, where you can now run `matflow --help`, or import `damask` or `damask_parse` in python.


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

