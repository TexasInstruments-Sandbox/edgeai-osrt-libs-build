#! /bin/bash
# This script should be run inside the CONTAINER

set -e
if [ ! -f /.dockerenv ]; then
    echo "This script should be run inside the osrt-build Docker container"
    exit 1
fi

current_dir=$(pwd)
NPROC=7

cd $WORK_DIR/workarea/neo-ai-dlr

SECONDS=0

rm -rf build
mkdir build
cd build
cmake -DUSE_TIDL=ON -DUSE_TIDL_RT_PATH=$(readlink -f ../../arm-tidl/rt) \
-DDLR_BUILD_TESTS=OFF -DCMAKE_TOOLCHAIN_FILE=../cmake/aarch64-linux-gcc-native.cmake ..

make clean
make -j$NPROC

echo "dlr_build.sh: Completed!"
duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."

cd $current_dir
