#! /bin/bash
# This script should be run on the host Linux / PSDK-Linux
# after building the vision-apps (in a seperate build system) and the OS-RT libs
# below is example for j784s4 and ubuntu:22.04
set -e

current_dir=$(pwd)

if [ -f /.dockerenv ]; then
    echo "You're inside a Docker container. This script should be run on the host Linux / PSDK-Linux"
    exit 1
fi

TARGET_DIR=$HOME/ubuntu22-deps

rm -rf $TARGET_DIR
mkdir -p $TARGET_DIR

# ROOT_DIR=/run/media/rootfs-sda2
ROOT_DIR=

lib_files=(
    # Vision-apps
    $ROOT_DIR/home/root/vision-apps-build/workarea/vision_apps/out/J784S4/A72/LINUX/release/libti-vision-apps-j784s4_9.2.0-ubuntu22.04.deb
    # ONNX
    $ROOT_DIR/home/root/osrt-build/workarea/onnxruntime/build/Linux/Release/dist/onnxruntime_tidl-1.14.0-cp310-cp310-linux_aarch64.whl
    $ROOT_DIR/home/root/osrt-build/workarea/onnx-1.14.0-ubuntu22.04_aarch64.tar.gz
    # TFLite
    $ROOT_DIR/home/root/osrt-build/workarea/tensorflow/tensorflow/lite/tools/pip_package/gen/tflite_pip/python3/dist/tflite_runtime-2.12.0-cp310-cp310-linux_aarch64.whl
    $ROOT_DIR/home/root/osrt-build/workarea/tflite-2.12-ubuntu22.04_aarch64.tar.gz
    # DLR
    $ROOT_DIR/home/root/osrt-build/workarea/neo-ai-dlr/python/dist/dlr-1.13.0-py3-none-any.whl
)

for lib_file in "${lib_files[@]}"; do
    cp "$lib_file" "$TARGET_DIR"
done

echo "collect_libs.sh: all the lib/whl files available on $TARGET_DIR"
find $TARGET_DIR -type f

cd $HOME
tar czf ubuntu22-deps.tar.gz ubuntu22-deps
cd $current_dir
