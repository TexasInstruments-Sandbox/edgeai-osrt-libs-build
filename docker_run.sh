#!/bin/bash

#  Copyright (C) 2021 Texas Instruments Incorporated - http://www.ti.com/
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

# ARCH: arm64
ARCH=arm64

# base image: ubuntu:22.04, ubuntu20.04, debian:12.5, ...
: "${BASE_IMAGE:=ubuntu:22.04}"

# SDK version
: "${SDK_VER:=9.2.0}"

# docker tag
DOCKER_TAG=dlrt-builder-${SDK_VER}:${ARCH}-${BASE_IMAGE//:/}
echo "DOCKER_TAG = $DOCKER_TAG"

if [ "$#" -lt 1 ]; then
    CMD=/bin/bash
else
    CMD="$@"
fi

docker run -it --rm \
    -v ${PWD}/scripts:/root/dlrt-build/scripts \
    -v ${PWD}/patches:/root/dlrt-build/patches \
    -v ${PWD}/workarea:/root/dlrt-build/workarea \
    --privileged \
    --network host \
    --env USE_PROXY=$USE_PROXY \
    --env ARCH=$ARCH \
    --env BASE_IMAGE=$BASE_IMAGE \
      $DOCKER_TAG $CMD
