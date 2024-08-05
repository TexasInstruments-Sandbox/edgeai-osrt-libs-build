#! /bin/bash
# This script should be run inside the CONTAINER
# Outputs:
# - onnxruntime/build/Linux/Release/libonnxruntime.so.1.14.0
# - onnxruntime/build/Linux/Release/dist/onnxruntime_tidl-1.14.0-cp38-cp38-linux_aarch64.whl

# protobuf options:
# a) in case of building protobuf from source
#    --path_to_protoc_exe $(pwd)/cmake/external/protobuf/src/protoc \
# b) in case of using pre-built protobuf
#    --path_to_protoc_exe $(pwd)/cmake/external/protoc-${PROTOBUF_VER}-linux-aarch_64/bin/protoc \
#    update PROTOBUF_VER as in onnxrt_prepare.sh

set -e
if [ ! -f /.dockerenv ]; then
    echo "This script should be run inside the osrt-build Docker container"
    exit 1
fi

current_dir=$(pwd)
NPROC=7

cd $WORK_DIR/workarea/onnxruntime

SECONDS=0

# update how many CPUs to use
PROTOBUF_VER=3.20.2
./build.sh --parallel $NPROC \
--compile_no_warning_as_error \
--skip_tests \
--enable_onnx_tests \
--build_shared_lib \
--config Release \
--cmake_extra_defines="CMAKE_TOOLCHAIN_FILE=$(pwd)/tool.cmake" \
--path_to_protoc_exe $(pwd)/cmake/external/protoc-${PROTOBUF_VER}-linux-aarch_64/bin/protoc \
--use_tidl \
--build_wheel

echo "onnxrt_build.sh: Completed!"
duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."

cd $current_dir
