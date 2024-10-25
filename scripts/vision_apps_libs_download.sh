#! /bin/bash

# base image: ubuntu:22.04, ubuntu20.04, debian:12.5, ...
: "${BASE_IMAGE:=ubuntu:22.04}"

# UPDATE this for each release
SDK_VER=10.0.0
SDK_VER_RC=10.00.00.08
URL_HEAD="https://github.com/TexasInstruments-Sandbox/edgeai-vision-apps-lib-build/releases/download/${SDK_VER_RC}"

if [ -f /.dockerenv ]; then
    echo "You're inside a Docker container. This script should be run on the host Linux"
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
if [ -d "${deb_dir}" ]; then
    rm -rf ${deb_dir}
fi
mkdir -p ${deb_dir}
cd ${deb_dir}

# download lib packages
for platform in ${platforms[@]}; do
    deb_pkg="libti-vision-apps-${platform}_${SDK_VER}-${BASE_IMAGE//:/}.deb"
    wget ${URL_HEAD}/${deb_pkg} || { echo "Failed to download ${deb_pkg}"; exit 1; }
done

cd $current_dir
