#! /bin/bash
source ${WORK_DIR}/scripts/utils.sh

if [ ! -f /.dockerenv ]; then
    echo "This script should be run inside the osrt-build Docker container"
    exit 1
fi

current_dir=$(pwd)

# parse repo info from config.yaml: repo_url, repo_tag, repo_branch, repo_commit
extract_repo_info "tensorflow"

# git clone
cd $WORK_DIR/workarea
clone_repo "$repo_url" "$repo_tag" "$repo_branch" "$repo_commit" tensorflow
cd tensorflow

# update build_pip_package_with_cmake.sh (for wheel package build)
copy_and_backup ../../patches/tensorflow/tensorflow/lite/tools/pip_package/build_pip_package_with_cmake.sh \
tensorflow/lite/tools/pip_package/build_pip_package_with_cmake.sh

cd $current_dir

echo "$(basename $0): Completed!"