#!/bin/bash

#  Copyright (C) 2024 Texas Instruments Incorporated - http://www.ti.com/
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions
#  are met:
#
#    Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
#    Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the
#    distribution.
#
#    Neither the name of Texas Instruments Incorporated nor the names of
#    its contributors may be used to endorse or promote products derived
#    from this software without specific prior written permission.
#
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
#  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
#  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
#  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
#  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
#  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
#  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
#  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
#  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

set -e

# ARCH: arm64
ARCH=arm64

# base image: ubuntu:22.04, ubuntu20.04, debian:12.5, ...
: "${BASE_IMAGE:=ubuntu:22.04}"

# SDK version
: "${SDK_VER:=10.1.0}"

# ti-rpmsg-char tag
: "${RPMSG_VER:=0.6.7}"

# docker tag
DOCKER_TAG=osrt-builder:${SDK_VER}-${ARCH}-${BASE_IMAGE//:/}
echo "DOCKER_TAG = $DOCKER_TAG"

if [ "$ARCH" == "arm64" ]; then
    BASE_IMAGE="arm64v8/${BASE_IMAGE}"
fi
echo "BASE_IMAGE = $BASE_IMAGE"

# for TI proxy network settings
: "${USE_PROXY:=0}"

# modify the server and proxy URLs as requied
if [ "${USE_PROXY}" -ne "0" ]; then
    HTTP_PROXY=http://webproxy.ext.ti.com:80
fi
echo "USE_PROXY = $USE_PROXY"

# copy files to be added while docker-build
# requirement: git-pull edgeai-ti-proxy repo and source edgeai-ti-proxy/setup_proxy.sh
DST_DIR=.
mkdir -p $DST_DIR/proxy
PROXY_DIR=$HOME/proxy
if [[ "$(arch)" == "aarch64" && "$(whoami)" == "root" ]]; then
    PROXY_DIR=/opt/proxy
fi
if [ -d "$PROXY_DIR" ]; then
    cp -rp $PROXY_DIR/* ${DST_DIR}/proxy
fi

# docker-build
SECONDS=0
docker build \
    -t $DOCKER_TAG \
    --build-arg ARCH=$ARCH \
    --build-arg BASE_IMAGE=$BASE_IMAGE \
    --build-arg USE_PROXY=$USE_PROXY \
    --build-arg HTTP_PROXY=$HTTP_PROXY \
    --build-arg RPMSG_VER=$RPMSG_VER \
    -f Dockerfile $DST_DIR
echo "Docker build -t $DOCKER_TAG completed!"
duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."

rm -rf ${DST_DIR}/proxy
