#! /bin/bash
# This script should be run on the host Linux / PSDK-Linux
# This script is for ubuntu:22.04, update as needed.
set -e

current_dir=$(pwd)

if [ -f /.dockerenv ]; then
    echo "You're inside a Docker container. This script should be run on the host Linux / PSDK-Linux"
    exit 1
fi

TARGET_DIR=$HOME/ubuntu22-deps

# rm -rf $TARGET_DIR
mkdir -p $TARGET_DIR

ROOT_DIR=""

lib_files=(
    # ONNX
    $ROOT_DIR/root/osrt-build/workarea/onnxruntime/build/Linux/Release/dist/onnxruntime_tidl-1.14.0-cp310-cp310-linux_aarch64.whl
    $ROOT_DIR/root/osrt-build/workarea/onnx-1.14.0-ubuntu22.04_aarch64.tar.gz
    # TFLite
    $ROOT_DIR/root/osrt-build/workarea/tensorflow/tensorflow/lite/tools/pip_package/gen/tflite_pip/python3/dist/tflite_runtime-2.12.0-cp310-cp310-linux_aarch64.whl
    $ROOT_DIR/root/osrt-build/workarea/tflite-2.12-ubuntu22.04_aarch64.tar.gz
    # DLR
    $ROOT_DIR/root/osrt-build/workarea/neo-ai-dlr/python/dist/dlr-1.13.0-py3-none-any.whl
    # TIDL runtime modules: J784S4
    $ROOT_DIR/root/osrt-build/workarea/arm-tidl/rt/out/J784S4/A72/LINUX/release/libvx_tidl_rt.so.1.0
    $ROOT_DIR/root/osrt-build/workarea/arm-tidl/onnxrt_ep/out/J784S4/A72/LINUX/release/libtidl_onnxrt_EP.so.1.0
    $ROOT_DIR/root/osrt-build/workarea/arm-tidl/onnxrt_ep/out/J784S4/A72/LINUX/release/libtidl_onnxrt_EP.so.1.0
    # TIDL runtime modules: J721S2
    $ROOT_DIR/root/osrt-build/workarea/arm-tidl/rt/out/J721S2/A72/LINUX/release/libvx_tidl_rt.so.1.0
    $ROOT_DIR/root/osrt-build/workarea/arm-tidl/onnxrt_ep/out/J721S2/A72/LINUX/release/libtidl_onnxrt_EP.so.1.0
    $ROOT_DIR/root/osrt-build/workarea/arm-tidl/onnxrt_ep/out/J721S2/A72/LINUX/release/libtidl_onnxrt_EP.so.1.0
    # TIDL runtime modules: J721E
    $ROOT_DIR/root/osrt-build/workarea/arm-tidl/rt/out/J721E/A72/LINUX/release/libvx_tidl_rt.so.1.0
    $ROOT_DIR/root/osrt-build/workarea/arm-tidl/onnxrt_ep/out/J721E/A72/LINUX/release/libtidl_onnxrt_EP.so.1.0
    $ROOT_DIR/root/osrt-build/workarea/arm-tidl/onnxrt_ep/out/J721E/A72/LINUX/release/libtidl_onnxrt_EP.so.1.0
    # TIDL runtime modules: J722S
    $ROOT_DIR/root/osrt-build/workarea/arm-tidl/rt/out/J722S/A53/LINUX/release/libvx_tidl_rt.so.1.0
    $ROOT_DIR/root/osrt-build/workarea/arm-tidl/onnxrt_ep/out/J722S/A53/LINUX/release/libtidl_onnxrt_EP.so.1.0
    $ROOT_DIR/root/osrt-build/workarea/arm-tidl/onnxrt_ep/out/J722S/A53/LINUX/release/libtidl_onnxrt_EP.so.1.0
    # TIDL runtime modules: AM62A
    $ROOT_DIR/root/osrt-build/workarea/arm-tidl/rt/out/AM62A/A53/LINUX/release/libvx_tidl_rt.so.1.0
    $ROOT_DIR/root/osrt-build/workarea/arm-tidl/onnxrt_ep/out/AM62A/A53/LINUX/release/libtidl_onnxrt_EP.so.1.0
    $ROOT_DIR/root/osrt-build/workarea/arm-tidl/onnxrt_ep/out/AM62A/A53/LINUX/release/libtidl_onnxrt_EP.so.1.0
)

for lib_file in "${lib_files[@]}"; do
    if [ -f "$lib_file" ]; then
        cp "$lib_file" "$TARGET_DIR"
    else
        echo "File $lib_file does not exist."
    fi
done

echo "collect_libs.sh: all the lib/whl files available on $TARGET_DIR"
find $TARGET_DIR -type f

# cd $HOME
# tar czf ubuntu22-deps.tar.gz ubuntu22-deps
cd $current_dir
