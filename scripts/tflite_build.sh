#! /bin/bash
# This script should be run inside the CONTAINER
# Output: <tensorflow_path>/tensorflow/tflite_build/libtensorflow-lite.a
set -e
if [ ! -f /.dockerenv ]; then
    echo "This script should be run inside the osrt-build Docker container"
    exit 1
fi

current_dir=$(pwd)
NPROC=7

cd $WORK_DIR/workarea/tensorflow

SECONDS=0

rm -rf tflite_build
mkdir tflite_build
cd tflite_build

# exprimental for "-Werror=stringop-overflow" error in ubuntu 24.04
ubuntu_version=$(lsb_release -a 2>/dev/null | grep 'Release' | cut -f2)
CMAKE_CXX_FLAGS_ADDITIONAL=""
if [ "$ubuntu_version" == "24.04" ]; then
    CMAKE_CXX_FLAGS_ADDITIONAL="-Wno-error=stringop-overflow"
fi

cmake -DCMAKE_C_COMPILER=gcc \
-DCMAKE_CXX_COMPILER=g++ \
-DCMAKE_C_FLAGS="-funsafe-math-optimizations" \
-DCMAKE_CXX_FLAGS="-funsafe-math-optimizations $CMAKE_CXX_FLAGS_ADDITIONAL" \
-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
-DCMAKE_SYSTEM_NAME=Linux \
-DTFLITE_ENABLE_XNNPACK=ON \
-DCMAKE_SYSTEM_PROCESSOR=aarch64 \
../tensorflow/lite/

cmake --build . -j$NPROC

echo "tflite_build.sh: Completed!"
duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."

cd $current_dir
