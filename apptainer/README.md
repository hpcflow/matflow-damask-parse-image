# Using apptainer (singularity) to run the matflow-damask-parse container

The docker container can be imported by apptainer and used mostly without problems.
However, the micromamba environment is not automatically loaded when a container is spun up, so a few tweaks are needed.

The Singularity file in this folder corrects this problem, and lets you use the container in the same way.

## Build the SIF image

First, update line 2 (which reads `FROM: ...`) of the Singularity file to make sure that the image source is pointing to the right place.

Then, to build the image, run
```
apptainer build matflow-damask-parse_latest.sif Singularity
```
The name of the sif file can be whatever you want, but make sure you reference the "Singularity" file at the end.

This should generate a matflow-damask-parse_latest.sif file, which is the apptainer/singularity version of your docker container.

## Using the SIF image

The sif file generated should activate the micromamba environment automatically for commands passed to it in the container call.
You can run it directly with, e.g.:
```
apptainer run -ce matflow-damask-parse_latest.sif matflow --version
```
The `-ce` flag is short for `--contain --cleanenv`, and although it is not absolutely necessary, it helps to sandbox your container.
If you need to pass multiple instrictions, wrap your commands with commas, e.g.:
apptainer run -ce matflow-damask-parse_latest.sif "matflow --version && matflow --hpcflow-version"

### File transfer between the container and host

In a similar way to the docker container, you can share files with the container by means of a mount. In apptainer/singularity, this is achieved with the flag `-B $PWD/wd:/wd/` to the command (`-B` is short for `--bind`).

This will map the `./wd` directory in your host machine to `/wd` in the container, which is where the command runs. Any outputs generated in this directory will also be available in the host machine (`./wd`).

For example,

```
apptainer run -ce -B $PWD/wd:/wd/ matflow-damask-parse_test.sif "matflow --version > hello.txt"
```

should create a `hello.txt` file in your host machine.

**WARNING**: any files that you modify in the container directory `/wd` will also be modified in the host system's `./wd`.

### Interactive use of the container

You can also create an interactive session with the container and work inside it.

Create the interactive session with:
```
apptainer shell -ce -B $PWD/wd/:/wd/ --pwd /wd matflow-damask-parse_latest.sif
```

Note the addition of the `--pwd /wd` flag, which places you in the right working directory inside the container.

You are now set to start using the container interactively.
