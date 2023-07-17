FROM mambaorg/micromamba:1.4.9

USER root
RUN <<SysReq
    apt-get update
    apt-get install -y libgl1-mesa-glx libxrender1
SysReq
USER $MAMBA_USER

COPY --chown=$MAMBA_USER envs.yaml /home/mambauser/.matflow-new/envs.yaml
RUN <<activate_micromamba
    micromamba create -n matflow_damask_parse_env python -y -c conda-forge
    eval "$(micromamba shell hook -s bash )"
    micromamba activate matflow_damask_parse_env
    pip install matflow-new damask-parse 
    matflow config append environment_sources envs.yaml
activate_micromamba
ENV ENV_NAME=matflow_damask_parse_env
