#!/bin/bash
#set -o nounset
set -o errexit
set -o pipefail

# Directories
home_dir=$PWD
work_dir="wd"

# Container variables
d_repo="ghcr.io/hpcflow"
image_n="matflow-damask-parse"
mdp_ver="latest"


# Setup script
sdir=$PWD
mkdir -p "$home_dir"/"$image_n"/"$work_dir"
cat << EntrypointScript > "$home_dir"/"$image_n"/"$work_dir"/entrypoint.sh
#!/bin/bash

# These two lines need to be at the start, do not remove them!
eval "\$(micromamba shell hook --shell bash)"
micromamba activate matflow_damask_parse_env

# Modify the instructions below as you please
matflow --version > matflow_version.txt

EntrypointScript
cat << RunScript > "$home_dir"/"$image_n"/run.sh
#!/bin/bash
#set -o nounset
set -o errexit
set -o pipefail

# Container variables
d_repo="$d_repo"
image_n="$image_n"
mdp_ver="$mdp_ver"

# Directories
work_dir="$work_dir"

[ -f "\$image_n"_"\$mdp_ver".sif ] || singularity pull docker://"\$d_repo"/"\$image_n":"\$mdp_ver"

singularity \\
        exec \\
            --contain \\
            --cleanenv \\
            --bind "\$work_dir"/:/tmp/ \\
            --pwd /tmp \\
            "\$image_n"_"\$mdp_ver".sif  \\
            ./entrypoint.sh

RunScript
cd "$home_dir"/"$image_n"/
chmod +x "$work_dir"/entrypoint.sh
chmod +x run.sh
./run.sh

# Success message
cd $sdir
cat << EOM

 Finished setting up.

 You can now cd into the directory:
   cd $home_dir/$image_n
 edit the entrypoint script:
   nano $work_dir/entrypoint.sh
 and run your code with:
   ./run.sh

EOM
