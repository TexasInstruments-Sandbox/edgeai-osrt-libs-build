#! /bin/bash
# This script should be run inside the CONTAINER
# TODO: use pre-built, e.g., "protoc-3.11.3-linux-aarch64.zip" and just unzip
# https://github.com/protocolbuffers/protobuf/releases/download/v3.11.3/protoc-3.11.3-linux-aarch_64.zip
cd onnxruntime
cd cmake/external/protobuf && ./autogen.sh && ./configure && make
cd -