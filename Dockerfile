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

ARG ARCH
ARG BASE_IMAGE
ARG USE_PROXY
ARG HTTP_PROXY
ARG DEBIAN_FRONTEND=noninteractive

#=========================================================================
FROM --platform=linux/${ARCH} ${BASE_IMAGE} AS base-0

#=========================================================================
FROM base-0 AS base-1
ARG USE_PROXY
ENV USE_PROXY=${USE_PROXY}
ARG HTTP_PROXY
ENV http_proxy=${HTTP_PROXY}
ENV https_proxy=${HTTP_PROXY}

#=========================================================================
FROM base-${USE_PROXY}
ARG ARCH
ARG BASE_IMAGE
ARG DEBIAN_FRONTEND
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# setup proxy settings
ADD setup_proxy.sh /root/
ADD proxy /root/proxy
RUN /root/setup_proxy.sh

# build-esssential and other tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake git wget curl unzip corkscrew vim && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install software-properties-common to use add-apt-repository
RUN apt-get update && apt-get install -y \
    software-properties-common && \
    rm -rf /var/lib/apt/lists/*

# python packages
# workaround for debian: add --break-system-packages
RUN apt-get update && apt-get install -y --no-install-recommends \
	libopenblas-dev \
    python3-dev \
    python3-pip \
    python3-setuptools && \
    if echo ${BASE_IMAGE} | grep -q "debian" || echo ${BASE_IMAGE} | grep -q "ubuntu:24.04"; then \
        python3 -m pip install --upgrade --break-system-packages pip; \
    else \
        python3 -m pip install --upgrade pip; \
    fi && \
    if echo ${BASE_IMAGE} | grep -q "debian" || echo ${BASE_IMAGE} | grep -q "ubuntu:24.04"; then \
        python3 -m pip install --break-system-packages numpy setuptools wheel pybind11 pytest; \
    else \
        python3 -m pip install numpy setuptools wheel pybind11 pytest; \
    fi && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# cmake >= 3.24
RUN apt-get remove cmake -y && \
    if echo ${BASE_IMAGE} | grep -q "debian" || echo ${BASE_IMAGE} | grep -q "ubuntu:24.04"; then \
        python3 -m pip install --upgrade --break-system-packages cmake; \
    else \
        python3 -m pip install --upgrade cmake; \
    fi && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ONNX-RT build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    xorg-server-source libtool automake && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# build and install ti-rpmsg-char: update the tag info in each release
WORKDIR /opt
RUN git clone git://git.ti.com/rpmsg/ti-rpmsg-char.git --branch 0.6.7 --depth 1 --single-branch && \
    cd /opt/ti-rpmsg-char && \
    autoreconf -i && ./configure --host=aarch64-none-linux-gnu --prefix=/usr && \
    make && make install && \
    rm -rf /opt/ti-rpmsg-char

# install libGLESv2, libEGL, libgbm-dev, libglm-dev, libdrm-dev
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgles2-mesa-dev \
    libegl-dev \
    libgbm-dev \
    libglm-dev \
    libdrm-dev && \
    rm -rf /var/lib/apt/lists/*

# install yq
RUN wget https://github.com/mikefarah/yq/releases/download/v4.44.3/yq_linux_${ARCH} -O /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq

#=========================================================================
# add scripts
COPY entrypoint.sh /root/entrypoint.sh

## .profile and .bashrc
WORKDIR /root
RUN echo "if [ -n \"$BASH_VERSION\" ]; then"     >  .profile && \
    echo "    # include .bashrc if it exists"    >> .profile && \
    echo "    if [ -f \"$HOME/.bashrc\" ]; then" >> .profile && \
    echo "        . \"$HOME/.bashrc\""           >> .profile && \
    echo "    fi"                                >> .profile && \
    echo "fi"                                    >> .profile && \
    echo "#!/bin/bash"                           >  .bashrc  && \
    echo "export PS1=\"${debian_chroot:+($debian_chroot)}\u@docker:\w\$ \"" >> .bashrc

# add label
LABEL TI_IMAGE_SOURCE=${BASE_IMAGE}

ENV WORK_DIR=/root/osrt-build
WORKDIR $WORK_DIR

# setup entrypoint
ENTRYPOINT ["/root/entrypoint.sh"]
