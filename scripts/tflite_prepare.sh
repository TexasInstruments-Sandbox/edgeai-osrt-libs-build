#! /bin/bash
current_dir=$(pwd)

# git clone
REPO_BRANCH="tidl-j7-2.12-latest"
REPO_TAG="a5870206f0c6addcb327b6095baab16639c1bd5c"
cd $WORK_DIR/workarea
git clone https://github.com/TexasInstruments/tensorflow.git --branch $REPO_BRANCH --single-branch tensorflow
cd tensorflow
git checkout $REPO_TAG

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
