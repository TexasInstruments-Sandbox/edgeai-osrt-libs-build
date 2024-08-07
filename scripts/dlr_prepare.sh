#! /bin/bash
# This script is expected to run inside the CONTAINER
set -e
if [ ! -f /.dockerenv ]; then
    echo "This script should be run inside the osrt-build Docker container"
    exit 1
fi

current_dir=$(pwd)

# clone the neo-ai-dlr repo
# REPO_BRANCH="tidl-j7"
DLR_TAG=TIDL_PSDK_10.0.2 # SHA: 2c932cf08f81f69a205e415b2cf3227107fb7ecb
cd $WORK_DIR/workarea
git clone --branch $DLR_TAG --depth 1 --single-branch https://github.com/TexasInstruments/neo-ai-dlr
cd neo-ai-dlr
git submodule update --quiet --init --recursive --depth=1
# update cmake file
cp ../../patches/neo-ai-dlr/cmake/aarch64-linux-gcc-native.cmake ./cmake

# clone the arm-tidl repo
REPO_TAG="REL.PSDK.ANALYTICS.10.00.00.03" # SHA: a171c3002a18ae7042cb620d8666545928e56b16
cd $WORK_DIR/workarea
git clone --branch $REPO_TAG --single-branch https://git.ti.com/git/processor-sdk-vision/arm-tidl.git

cd $current_dir
