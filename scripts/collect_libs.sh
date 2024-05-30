#! /bin/bash
# This script should be run on the host Linux (PSDK-Linux)
# after building the vision-apps (in a seperate build system) and the OS-RT libs

TARGET_DIR=/opt/ubuntu22-libs

rm -rf $TARGET_DIR
mkdir -p $TARGET_DIR

# ROOT_DIR=/run/media/rootfs-sda2
ROOT_DIR=

lib_files=(
    # Vision-apps
    # $ROOT_DIR/home/root/vision-apps-build/workarea/vision_apps/out/J784S4/A72/LINUX/release/libtivision_apps.so.9.2.0
    $ROOT_DIR/home/root/vision-apps-build/workarea/vision_apps/out/J784S4/A72/LINUX/release/libti-vision-apps-j784s4_9.2.0-ubuntu22.04.deb
    # ONNX
    # $ROOT_DIR/home/root/dlrt-build/workarea/onnxruntime/build/Linux/Release/libonnxruntime.so.1.14.0
    $ROOT_DIR/home/root/dlrt-build/workarea/onnxruntime/build/Linux/Release/dist/onnxruntime_tidl-1.14.0-cp310-cp310-linux_aarch64.whl
    $ROOT_DIR/home/root/dlrt-build/workarea/onnx-1.14.0-ubuntu22_aarch64.tar.gz
    # TFLite
    # $ROOT_DIR/home/root/dlrt-build/workarea/tensorflow/tflite_build/libtensorflow-lite.a
    $ROOT_DIR/home/root/dlrt-build/workarea/tensorflow/tensorflow/lite/tools/pip_package/gen/tflite_pip/python3/dist/tflite_runtime-2.12.0-cp310-cp310-linux_aarch64.whl
    $ROOT_DIR/home/root/dlrt-build/workarea/tflite-2.12-ubuntu22_aarch64.tar.gz
    # DLR
    $ROOT_DIR/home/root/dlrt-build/workarea/neo-ai-dlr/python/dist/dlr-1.13.0-py3-none-any.whl
)

for lib_file in "${lib_files[@]}"; do
    cp "$lib_file" "$TARGET_DIR"
done

echo "collect_libs.sh: all the lib/whl files available on $TARGET_DIR"
find $TARGET_DIR -type f
