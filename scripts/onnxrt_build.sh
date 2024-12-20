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

source ${WORK_DIR}/scripts/utils.sh

if [ ! -f /.dockerenv ]; then
    echo "This script should be run inside the osrt-build Docker container"
    exit 1
fi

current_dir=$(pwd)
NPROC=7
protobuf_ver=$(get_yaml_value "onnxruntime" "protobuf_ver")

cd $WORK_DIR/workarea/onnxruntime

SECONDS=0

# update how many CPUs to use
./build.sh --parallel $NPROC \
--compile_no_warning_as_error \
--skip_tests \
--enable_onnx_tests \
--build_shared_lib \
--config Release \
--cmake_extra_defines="CMAKE_TOOLCHAIN_FILE=$(pwd)/tool.cmake" \
--path_to_protoc_exe $(pwd)/cmake/external/protoc-${protobuf_ver}-linux-aarch_64/bin/protoc \
--use_tidl \
--build_wheel \
--allow_running_as_root

# chmod
chmod -R a+w $WORK_DIR/workarea

echo "onnxrt_build.sh: Completed!"
duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."

cd $current_dir

echo "$(basename $0): Completed!"