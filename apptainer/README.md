# Using apptainer (singularity) to run the matflow-damask-parse container

The docker container can be imported by apptainer and used mostly without problems

However, the micromamba environment is not automatically loaded when a container is spun up, so a few tweaks are needed.

The simplest way is to copy and execute the `setup_apptainer.sh` script to the host machine.

## Using the setup script
The setup script assumes there is a working installation of apptainer (singularity) on the host machine.

You can directly run the setup script with:
```
./setup_apptainer.sh
```

By default, this will create a `matflow-damask-parse` folder with a working directory (`wd`) subfolder.
This folder will be mounted in the container when it runs.
It will also configure the `run.sh` and `entrypoint.sh` scripts, and import the `matflow-damask-parse:latest` image to singularity.
Finally, it will test the setup is correct by running the container once, and output the version of matflow to a text file.

If everything runs smoothly, you should en up with a file structure like this:
```
├── matflow-damask-parse
│   ├── matflow-damask-parse_latest.sif
│   ├── run.sh
│   └── wd
│       ├── entrypoint.sh
│       └── matflow_version.txt
│
└── setup_apptainer.sh
```

At this point, feel free to delete `setup_apptainer.sh`, and `matflow_version.txt`.

### Running a script inside the container

When you execute the script `run.sh` it calls the container with `wd` mounted and executes `entrypoint.sh` inside the container.

Therefore, it is the script `entrypoint.sh` where you should add instructions on what to do inside the container.

For example, you can replace line 8 of the script with:
```
python -c "from pathlib import Path; Path('greetings.txt').write_text('Hello from the matflow-damask-parse container.');"
```
Save your changes to `entrypoint.sh`, and use the run script:
```
./run.sh
```
You should see the greetings file appear in the wd directory.


### Configuring the setup script

You can configure:

- Where the `matflow-damask-parse` directory is created, by modifying the `home_dir` variable.
- The name of the folder that will be mounted in the container, by modifying the `work_dir` variable.
- The version of the `matflow-damask-parse` image, by modifying the `mdp_ver` variable.

If you have a custom image that you want to test, you may even configure the repository where the image is held (`d_repo` variable), 
or the name of the docker image (`image_n` variable), but make sure you know what you are doing...


## Interactive use of container

You can also create an interactive session with the container and work inside it.

First, make sure you have imported the container to apptainer (singularity):
```
apptainer pull docker://ghcr.io/hpcflow/matflow-damask-parse:latest
```

Then create the interactive session with:
```
apptainer shell --contain --cleanenv --bind $PWD/wd/:/tmp/ --pwd /tmp matflow-damask-parse_latest.sif
```

Once inside the container, make sure to activate the micromamba environment with:
```
eval "$(micromamba shell hook --shell bash)"
micromamba activate matflow_damask_parse_env
```

You are now set to start using the container interactively.
