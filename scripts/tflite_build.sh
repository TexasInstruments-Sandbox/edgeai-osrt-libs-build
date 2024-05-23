#! /bin/bash
# This script should be run inside the CONTAINER
# Output: <tensorflow_path>/tensorflow/tflite_build/libtensorflow-lite.a

current_dir=$(pwd)

cd $WORK_DIR/workarea/tensorflow

SECONDS=0

rm -rf tflite_build
mkdir tflite_build
cd tflite_build

cmake -DCMAKE_C_COMPILER=gcc \
-DCMAKE_CXX_COMPILER=g++ \
-DCMAKE_C_FLAGS="-funsafe-math-optimizations" \
-DCMAKE_CXX_FLAGS="-funsafe-math-optimizations" \
-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
-DCMAKE_SYSTEM_NAME=Linux \
-DTFLITE_ENABLE_XNNPACK=ON \
-DCMAKE_SYSTEM_PROCESSOR=aarch64 \
../tensorflow/lite/

NPROC=7
cmake --build . -j$NPROC

echo "tflite_build.sh: Completed!"
duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."

cd $current_dir
