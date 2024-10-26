#! /bin/bash
# This script is expected to run inside the CONTAINER
source ${WORK_DIR}/scripts/utils.sh

if [ ! -f /.dockerenv ]; then
    echo "This script should be run inside the osrt-build Docker container"
    exit 1
fi

current_dir=$(pwd)

# clone the neo-ai-dlr repo
# parse repo info from config.yaml: repo_url, repo_tag, repo_branch, repo_commit
extract_repo_info "neo-ai-dlr"
cd $WORK_DIR/workarea
clone_repo "$repo_url" "$repo_tag" "$repo_branch" "$repo_commit" neo-ai-dlr
cd neo-ai-dlr
git submodule update --quiet --init --recursive --depth=1
# update cmake file
cp ../../patches/neo-ai-dlr/cmake/aarch64-linux-gcc-native.cmake ./cmake

# clone the arm-tidl repo
extract_repo_info "arm-tidl"
cd $WORK_DIR/workarea
clone_repo "$repo_url" "$repo_tag" "$repo_branch" "$repo_commit" arm-tidl

cd $current_dir

echo "$(basename $0): Completed!"