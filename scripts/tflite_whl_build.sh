#! /bin/bash
# This script should be run inside the CONTAINER
if [ ! -f /.dockerenv ]; then
    echo "This script should be run inside the osrt-build Docker container"
    exit 1
fi

current_dir=$(pwd)

cd $WORK_DIR/workarea/tensorflow

SECONDS=0

# build python wheel package
PYTHON=python3 BUILD_NUM_JOBS=7 tensorflow/lite/tools/pip_package/build_pip_package_with_cmake.sh aarch64

echo "tflite_whl_build.sh: Completed!"
duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."

cd $current_dir

echo "$(basename $0): Completed!"