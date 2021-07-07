#! /bin/bash
# This script should be run inside the CONTAINER
# make protoc inside onnxruntime submodules
# TODO: use pre-built, e.g., "protoc-3.11.2-linux-aarch64.zip" and just unzip
cd onnxruntime
cd cmake/external/protobuf && ./autogen.sh && ./configure && make
cd -