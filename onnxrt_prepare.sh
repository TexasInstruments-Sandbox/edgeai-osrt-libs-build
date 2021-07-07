#! /bin/bash
git clone --single-branch https://github.com/microsoft/onnxruntime onnxruntime
cd onnxruntime
git checkout -b tidl_branch c8e2e3191b2d506d1260069eb3d3fc7c262ec172

# TODO: it looks like this is part of build.sh, but maybe required to build protobuf
# Q: is "build protobuf" part of build.sh?
git submodule init
git submodule update --init --recursive

# apply patch (Edge AI 0.5)
git am ../patches/onnxrt/0001-Add-TIDL-compilation-execution-providers.patch

# update tool.cmake
cp ../patches/onnxrt/tool.cmake .
cd -

# pre-built protobuf
# update PROTOBUF_VER by, e.g., "git log" at onnxruntime/cmake/external/protoc
PROTOBUF_VER=3.11.3
PROTOBUF_URL=https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_VER}/protoc-${PROTOBUF_VER}-linux-aarch_64.zip
wget $PROTOBUF_URL
unzip protoc-${PROTOBUF_VER}-linux-aarch_64.zip -d onnxruntime/cmake/external/protoc-${PROTOBUF_VER}-linux-aarch_64
