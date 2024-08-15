#! /bin/bash
# This script should be run on the host Linux / PSDK-Linux
# This script is for ubuntu:22.04, update as needed.
set -e
if [ ! -f /.dockerenv ]; then
    echo "This script should be run inside the osrt-build Docker container"
    exit 1
fi

current_dir=$(pwd)

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
# Requirement: vision-apps debian packages should be located under ${HOME}/ubuntu22-deps
echo "======> TIDL Modules"
./tidl_prepare.sh
./tidl_build.sh

cd $current_dir
