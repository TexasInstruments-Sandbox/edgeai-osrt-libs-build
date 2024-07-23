#! /bin/bash
# This script is expected to run inside the CONTAINER
current_dir=$(pwd)

# clone the neo-ai-dlr repo
DLR_TAG=TIDL_PSDK_10.0.0
cd $WORK_DIR/workarea
git clone --branch $DLR_TAG --depth 1 --single-branch https://github.com/TexasInstruments/neo-ai-dlr
cd neo-ai-dlr
git submodule update --quiet --init --recursive --depth=1
# update cmake file
cp ../../patches/neo-ai-dlr/cmake/aarch64-linux-gcc-native.cmake ./cmake

# clone the arm-tidl repo
REPO_TAG="REL.PSDK.ANALYTICS.10.00.00.01"
cd $WORK_DIR/workarea
git clone --branch $REPO_TAG --single-branch https://git.ti.com/git/processor-sdk-vision/arm-tidl.git

cd $current_dir
