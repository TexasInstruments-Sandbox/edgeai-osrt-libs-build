#! /bin/bash
# This script should be run inside the CONTAINER
# This can be skipped if you want to use pre-built protobuf
cd onnxruntime
cd cmake/external/protobuf && ./autogen.sh && ./configure && make
cd -