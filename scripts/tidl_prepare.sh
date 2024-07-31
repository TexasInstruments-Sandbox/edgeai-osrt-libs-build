#! /bin/bash
# This script is expected to run inside the CONTAINER
# Depend: onnrt_prepare.sh, tflite_prepare.sh, dlr_prepare.sh

set -e

current_dir=$(pwd)
cd ${WORK_DIR}/workarea

# clone concerto
REPO_TAG=REL.PSDK.ANALYTICS.10.00.00.02 # SHA: 38b9190a5d335e58d81d21e3e058b11e5c47c605
REPO_DIR="${WORK_DIR}/workarea/concerto"
if [ ! -d "$REPO_DIR" ]; then
    git clone https://git.ti.com/git/processor-sdk/concerto.git --branch $REPO_TAG --depth 1 --single-branch
else
    echo "Directory $REPO_DIR already exists. Skipping."
fi

# protobuf source
PROTOBUF_VER=3.20.2
REPO_DIR="${WORK_DIR}/workarea/protobuf-${PROTOBUF_VER}"
if [ ! -d "$REPO_DIR" ]; then
    wget -q https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_VER}/protobuf-cpp-${PROTOBUF_VER}.tar.gz
    tar -xzf protobuf-cpp-${PROTOBUF_VER}.tar.gz
else
    echo "Directory $REPO_DIR already exists. Skipping."
fi

# onnxrt
REPO_DIR="${WORK_DIR}/workarea/onnxruntime"
if [ ! -d "$REPO_DIR" ]; then
    bash ${WORK_DIR}/scripts/onnxrt_prepare.sh
else
    echo "Directory $REPO_DIR already exists. Skipping."
fi

# tflite-rt
REPO_DIR="${WORK_DIR}/workarea/tensorflow"
if [ ! -d "$REPO_DIR" ]; then
    bash ${WORK_DIR}/scripts/tflite_prepare.sh
else
    echo "Directory $REPO_DIR already exists. Skipping."
fi

# arm-tidl
REPO_DIR="${WORK_DIR}/workarea/arm-tidl"
if [ ! -d "$REPO_DIR" ]; then
    bash ${WORK_DIR}/scripts/dlr_prepare.sh
else
    echo "Directory $REPO_DIR already exists. Skipping."
fi

cd ${current_dir}
