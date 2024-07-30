#! /bin/bash
current_dir=$(pwd)

# git clone
# REPO_BRANCH="tidl-j7-2.12"
REPO_TAG="REL.TIDL.10.00.00.03" # SHA: 422156a973b23bab6b86176a245a66193dccb995

cd $WORK_DIR/workarea
git clone https://github.com/TexasInstruments/tensorflow.git --branch $REPO_TAG --depth 1 --single-branch tensorflow
cd tensorflow

# define a function to copy a file and backup the original if it exists
copy_and_backup() {
    src_file=$1
    dest_file=$2
    if [ -f "$dest_file" ]; then
        mv  $dest_file $dest_file.ORG
    fi
    cp $src_file $dest_file
}

# update build_pip_package_with_cmake.sh (for wheel package build)
copy_and_backup ../../patches/tensorflow/tensorflow/lite/tools/pip_package/build_pip_package_with_cmake.sh \
tensorflow/lite/tools/pip_package/build_pip_package_with_cmake.sh

cd $current_dir
