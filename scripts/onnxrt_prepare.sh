#! /bin/bash
source ${WORK_DIR}/scripts/utils.sh

if [ ! -f /.dockerenv ]; then
    echo "This script should be run inside the osrt-build Docker container"
    exit 1
fi

current_dir=$(pwd)

# parse repo info from config.yaml: repo_url, repo_tag, repo_branch, repo_commit
extract_repo_info "onnxruntime"

# git clone
cd $WORK_DIR/workarea
clone_repo "$repo_url" "$repo_tag" "$repo_branch" "$repo_commit" onnxruntime
cd onnxruntime

# TODO: it looks like this is part of build.sh, but maybe required to build protobuf
# Q: is "build protobuf" part of build.sh?
git submodule init
git submodule update --init --recursive

# update tool.cmake
# TODO: eleminate this step. Instead pass env variables.
mv tool.cmake tool.cmake_ORG
cp ../../patches/onnxruntime/tool.cmake .

# pre-built protobuf
# update protobuf_ver by, e.g., "git log" at <onnxruntime>/cmake/external/protobuf
protobuf_ver=$(get_yaml_value "onnxruntime" "protobuf_ver")
zip_file="protoc-${protobuf_ver}-linux-aarch_64.zip"
cd $WORK_DIR/workarea
curl -O -L "https://github.com/protocolbuffers/protobuf/releases/download/v${protobuf_ver}/${zip_file}"
unzip "$zip_file" -d "onnxruntime/cmake/external/protoc-${protobuf_ver}-linux-aarch_64"
rm "$zip_file"

cd $current_dir

echo "$(basename $0): Completed!"