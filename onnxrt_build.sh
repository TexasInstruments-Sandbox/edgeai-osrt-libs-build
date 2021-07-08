#! /bin/bash
# This script should be run inside the CONTAINER
# Outputs:
# - onnxruntime/build/Linux/Release/libonnxruntime.so.1.7.0
# - onnxruntime/build/Linux/Release/dist/onnxruntime_tidl-1.7.0-cp36-cp36m-linux_aarch64.whl

# protobuf options:
# a) in case of building protobuf from source
# --path_to_protoc_exe $(pwd)/cmake/external/protobuf/src/protoc \
# b) in case of using pre-built protobuf
# --path_to_protoc_exe $(pwd)/cmake/external/protoc-3.11.3-linux-aarch_64/bin/protoc \

# update how many CPUs to use
NPROC=10
cd onnxruntime
./build.sh --parallel $NPROC \
--skip_tests \
--enable_onnx_tests \
--build_shared_lib \
--config Release \
--cmake_extra_defines="CMAKE_TOOLCHAIN_FILE=$(pwd)/tool.cmake" \
# --path_to_protoc_exe $(pwd)/cmake/external/protobuf/src/protoc \
--path_to_protoc_exe $(pwd)/cmake/external/protoc-3.11.3-linux-aarch_64/bin/protoc \
--use_tidl \
--build_wheel
cd -
