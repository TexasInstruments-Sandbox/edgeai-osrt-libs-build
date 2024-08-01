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
    # TODO: check why "+10000000" was added in the whl package name
    # $ROOT_DIR/root/osrt-build/workarea/onnxruntime/build/Linux/Release/dist/onnxruntime_tidl-1.14.0-cp310-cp310-linux_aarch64.whl
    $ROOT_DIR/root/osrt-build/workarea/onnxruntime/build/Linux/Release/dist/onnxruntime_tidl-1.14.0+10000000-cp310-cp310-linux_aarch64.whl
    $ROOT_DIR/root/osrt-build/workarea/onnx-1.14.0-ubuntu22.04_aarch64.tar.gz
    # TFLite
    $ROOT_DIR/root/osrt-build/workarea/tensorflow/tensorflow/lite/tools/pip_package/gen/tflite_pip/python3/dist/tflite_runtime-2.12.0-cp310-cp310-linux_aarch64.whl
    $ROOT_DIR/root/osrt-build/workarea/tflite-2.12-ubuntu22.04_aarch64.tar.gz
    # DLR
    $ROOT_DIR/root/osrt-build/workarea/neo-ai-dlr/python/dist/dlr-1.13.0-py3-none-any.whl
)

for lib_file in "${lib_files[@]}"; do
    if [ -f "$lib_file" ]; then
        cp "$lib_file" "$TARGET_DIR"
    else
        echo "Error: File $lib_file does not exist."
        exit 1
    fi
done

# temporary
mv $TARGET_DIR/onnxruntime_tidl-1.14.0+10000000-cp310-cp310-linux_aarch64.whl $TARGET_DIR/onnxruntime_tidl-1.14.0-cp310-cp310-linux_aarch64.whl

# collect the TIDL modules: under $TARGET_DIR/arm-tidl/$platform
copy_lib_files() {
    local target_dir=$1
    shift
    local lib_files=("$@")

    mkdir -p "$TARGET_DIR/arm-tidl/$target_dir"
    for lib_file in "${lib_files[@]}"; do
        if [ -f "$lib_file" ]; then
            cp "$lib_file" "$TARGET_DIR/arm-tidl/$target_dir"
        else
            echo "Error: File $lib_file does not exist."
            exit 1
        fi
    done
}

platforms=("j784s4" "j721s2" "j721e" "j722s" "am62a")
mpus=("A72" "A72" "A72" "A53" "A53")

for i in "${!platforms[@]}"; do
    platform=${platforms[$i]}
    mpu=${mpus[$i]}

    tidl_lib_files=(
        "$ROOT_DIR/root/osrt-build/workarea/arm-tidl/rt/out/${platform^^}/${mpu}/LINUX/release/libvx_tidl_rt.so.1.0"
        "$ROOT_DIR/root/osrt-build/workarea/arm-tidl/onnxrt_ep/out/${platform^^}/${mpu}/LINUX/release/libtidl_onnxrt_EP.so.1.0"
        "$ROOT_DIR/root/osrt-build/workarea/arm-tidl/tfl_delegate/out/${platform^^}/${mpu}/LINUX/release/libtidl_tfl_delegate.so.1.0"
    )

    copy_lib_files "$platform" "${tidl_lib_files[@]}"
done

echo "collect_libs.sh: all the lib/whl files available on $TARGET_DIR"
find $TARGET_DIR -type f

# cd $HOME
# tar czf ubuntu22-deps.tar.gz ubuntu22-deps
cd $current_dir
