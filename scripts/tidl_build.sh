#! /bin/bash
# TIDL runtime modules: TIDL-RT, TFlite-RT delegate lib and ONNX-RT execution provider lib

# Requirement: vision-apps debian packages are required which can be separately
# built with "vision-apps-build".
# Please place the vision-apps debian packages under ${WORK_DIR}/workarea.

set -e

current_dir=$(pwd)

PROTOBUF_VER=3.20.2
export CONCERTO_ROOT=${WORK_DIR}/workarea/concerto
TARGET_FS=""

cd $WORK_DIR/workarea/arm-tidl

# target platforms
platforms=(
    j784s4
    j721s2
    j721e
    j722s
    am62a
)

# scrub
make rt_scrub tfl_delegate_scrub onnxrt_ep_scrub

# iterate over the platforms
for platform in ${platforms[@]}; do
    echo "Building for $platform ..."

    # install vision-apps.deb package
    DEB_PKG=libti-vision-apps-${platform}_${SDK_VER}-${BASE_IMAGE//:/}.deb
    if [ -f "${WORK_DIR}/workarea/${DEB_PKG}" ]; then
        dpkg -i ${WORK_DIR}/workarea/${DEB_PKG}
    else
        echo "File $DEB_PKG does not exist."
        exit 1
    fi

    # clean up
    make rt_clean tfl_delegate_clean onnxrt_ep_clean

    # build:
    # makerules available - all: rt tfl_delegate onnxrt_ep
    make -C ${WORK_DIR}/workarea/arm-tidl \
        PSDK_INSTALL_PATH=${WORK_DIR}/workarea/ \
        IVISION_PATH=${TARGET_FS}/usr/include/processor_sdk/ivision \
        VISION_APPS_PATH=${TARGET_FS}/usr/include/processor_sdk/vision_apps \
        APP_UTILS_PATH=${TARGET_FS}/usr/include/processor_sdk/app_utils \
        TIOVX_PATH=${TARGET_FS}/usr/include/processor_sdk/tiovx \
        LINUX_FS_PATH=${TARGET_FS} \
        CONCERTO_ROOT=${WORK_DIR}/workarea/concerto \
        TF_REPO_PATH=${WORK_DIR}/workarea/tensorflow \
        ONNX_REPO_PATH=${WORK_DIR}/workarea/onnxruntime \
        TIDL_PROTOBUF_PATH=${WORK_DIR}/workarea/protobuf-${PROTOBUF_VER} \
        GCC_LINUX_ARM_ROOT=/usr \
        TARGET_SOC=${platform} \
        CROSS_COMPILE_LINARO= \
        LINUX_SYSROOT_ARM=$TARGET_FS \
        TREAT_WARNINGS_AS_ERROR=0

    # uninstall vision-apps.deb package
    dpkg -r libti-vision-apps-${platform}

done

cd $current_dir
