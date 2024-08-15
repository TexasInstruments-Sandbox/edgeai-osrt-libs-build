#! /bin/bash
# This script is expected to run inside the CONTAINER
# Depend: onnrt_prepare.sh, tflite_prepare.sh, dlr_prepare.sh
set -e
source utils.sh

if [ ! -f /.dockerenv ]; then
    echo "This script should be run inside the osrt-build Docker container"
    exit 1
fi

current_dir=$(pwd)
cd ${WORK_DIR}/workarea

# clone concerto
# parse repo info from config.yaml: repo_url, repo_tag, repo_branch, repo_commit
extract_repo_info "concerto"
REPO_DIR="${WORK_DIR}/workarea/concerto"
if [ ! -d "$REPO_DIR" ]; then
    clone_repo "$repo_url" "$repo_tag" "$repo_branch" "$repo_commit" concerto
else
    echo "Directory $REPO_DIR already exists. Skipping."
fi

# protobuf source
PROTOBUF_VER=$(get_yaml_value "onnxruntime" "protobuf_ver")
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
