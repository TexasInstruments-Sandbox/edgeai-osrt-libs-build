#! /bin/bash
current_dir=$(pwd)

# git clone
# REPO_BRANCH="tidl-1.14"
REPO_TAG="REL.TIDL.10.00.00.03" # SHA: 696c7c5074c28b27a8d1d6b70c45eb02bfcea4e5
cd $WORK_DIR/workarea
git clone https://github.com/TexasInstruments/onnxruntime.git --branch $REPO_TAG --depth 1 --single-branch onnxruntime
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
# update PROTOBUF_VER by, e.g., "git log" at <onnxruntime>/cmake/external/protobuf
PROTOBUF_VER=3.20.2
ZIP_FILE=protoc-${PROTOBUF_VER}-linux-aarch_64.zip
cd $WORK_DIR/workarea
curl -O -L https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_VER}/${ZIP_FILE}
unzip ${ZIP_FILE} -d onnxruntime/cmake/external/protoc-${PROTOBUF_VER}-linux-aarch_64
rm ${ZIP_FILE}

cd $current_dir
