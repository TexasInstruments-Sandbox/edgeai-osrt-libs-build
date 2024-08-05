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
function copy_vision_apps_deb_files() {
    local SRC_DIR=$HOME/ubuntu22-deps
    local DST_DIR=$WORK_DIR/workarea
    local lib_files=(
        # Vision-apps libs for all the platforms
        $SRC_DIR/libti-vision-apps-j784s4_10.0.0-ubuntu22.04.deb
        $SRC_DIR/libti-vision-apps-j721s2_10.0.0-ubuntu22.04.deb
        $SRC_DIR/libti-vision-apps-j721e_10.0.0-ubuntu22.04.deb
        $SRC_DIR/libti-vision-apps-j722s_10.0.0-ubuntu22.04.deb
        $SRC_DIR/libti-vision-apps-am62a_10.0.0-ubuntu22.04.deb
    )

    for lib_file in "${lib_files[@]}"; do
        if [ -f "$lib_file" ]; then
            cp "$lib_file" "$DST_DIR"
        else
            echo "Error: File $lib_file does not exist."
            exit 1
        fi
    done
}
copy_vision_apps_deb_files
./tidl_prepare.sh
./tidl_build.sh

cd $current_dir
