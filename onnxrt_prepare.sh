#! /bin/bash
REPO_BRANCH="tidl-j7"
REPO_TAG="TIDL_PSDK_8.0"
git clone https://github.com/TexasInstruments/onnxruntime.git --branch $REPO_BRANCH --single-branch onnxruntime
cd onnxruntime
git checkout $REPO_TAG

# TODO: it looks like this is part of build.sh, but maybe required to build protobuf
# Q: is "build protobuf" part of build.sh?
git submodule init
git submodule update --init --recursive

# update tool.cmake
cp ../patches/onnxrt/tool.cmake .
cd -

# pre-built protobuf
# update PROTOBUF_VER by, e.g., "git log" at <onnxruntime>/cmake/external/protobuf
PROTOBUF_VER=3.11.3
ZIP_FILE=protoc-${PROTOBUF_VER}-linux-aarch_64.zip
wget https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_VER}/${ZIP_FILE}
unzip ${ZIP_FILE} -d onnxruntime/cmake/external/protoc-${PROTOBUF_VER}-linux-aarch_64
