#! /bin/bash
# This script is expected to run inside the CONTAINER
set -e
source ${WORK_DIR}/scripts/utils.sh

# base image: ubuntu:22.04, ubuntu20.04, debian:12.5, ...
: "${BASE_IMAGE:=ubuntu:22.04}"

# params
url=$(get_yaml_value "vision-apps-lib-build" "url")
release=$(get_yaml_value "vision-apps-lib-build" "release")
sdk_ver=$(get_yaml_value "vision-apps-lib-build" "sdk_ver")

if [ ! -f /.dockerenv ]; then
    echo "This script should be run inside the osrt-build Docker container"
    exit 1
fi

# target platforms
platforms=(
    j784s4
    j721s2
    j721e
    j722s
    am62a
)

current_dir=$(pwd)
deb_dir="${HOME}/${BASE_IMAGE//:/}-deps"

# check if the directory exists
if [ ! -d "${deb_dir}" ]; then
    echo "${deb_dir} does not exist."
    exit 1
fi
cd ${deb_dir}

# check if the directory is not empty
if [ "$(ls -A $deb_dir)" ]; then
   echo "$DIR is not empty. Removing all files..."
   rm -rf $deb_dir/*
fi

# download lib packages
for platform in ${platforms[@]}; do
    deb_pkg="libti-vision-apps-${platform}_${sdk_ver}-${BASE_IMAGE//:/}.deb"
    wget ${url}/${release}/${deb_pkg} || { echo "Failed to download ${deb_pkg}"; exit 1; }
done

cd $current_dir

echo "vision_apps_libs_download.sh: Completed!"
