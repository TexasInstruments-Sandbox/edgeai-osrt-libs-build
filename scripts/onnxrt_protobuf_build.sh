#! /bin/bash
# This script should be run inside the CONTAINER
# This can be skipped if you want to use pre-built protobuf
if [ ! -f /.dockerenv ]; then
    echo "This script should be run inside the osrt-build Docker container"
    exit 1
fi

current_dir=$(pwd)
cd $WORK_DIR/workarea

cd onnxruntime
cd cmake/external/protobuf && ./autogen.sh && ./configure && make

cd $current_dir

echo "$(basename $0): Completed!"