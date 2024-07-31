#! /bin/bash
# This script should be run on the host Linux / PSDK-Linux
# This script is for ubuntu:22.04, update as needed.
set -e

current_dir=$(pwd)

if [ -f /.dockerenv ]; then
    echo "You're inside a Docker container. This script should be run on the host Linux / PSDK-Linux"
    exit 1
fi

cd $WORK_DIR/scripts

# ONNX-RT
echo "======> ONNX-RT"
./onnxrt_prepare.sh
./onnxrt_build.sh
./onnxrt_package.sh

# TFLite-RT
echo "======> TFLite-RT"
./tflite_prepare.sh
./tflite_build.sh
./tflite_whl_build.sh
./tflite_package.sh

# TVM-DLR
echo "======> TVM-DLR"
./dlr_prepare.sh
./dlr_build.sh
./dlr_package.sh

# TIDL Modules
echo "======> TIDL Modules"
./tidl_prepare.sh
./tidl_build.sh

cd $current_dir
