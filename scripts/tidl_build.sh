#! /bin/bash
# TIDL runtime modules: TIDL-RT, TFlite-RT delegate lib and ONNX-RT execution provider lib

# Requirement: vision-apps debian packages are required which can be separately
# built with "vision-apps-build".
# Please place the vision-apps debian packages under ${HOME}/ubuntu22-deps.
# docker_run.sh has -v ${HOME}/ubuntu22-deps:/root/ubuntu22-deps
set -e
source ${WORK_DIR}/scripts/utils.sh

if [ ! -f /.dockerenv ]; then
    echo "This script should be run inside the osrt-build Docker container"
    exit 1
fi

current_dir=$(pwd)

protobuf_ver=$(get_yaml_value "onnxruntime" "protobuf_ver")
export CONCERTO_ROOT=${WORK_DIR}/workarea/concerto
TARGET_FS=""

cd "$WORK_DIR/workarea/arm-tidl"

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
    deb_pkg="libti-vision-apps-${platform}_${SDK_VER}-${BASE_IMAGE//:/}.deb"
    deb_path="${HOME}/ubuntu22-deps/${deb_pkg}"
    if [ -f "$deb_path" ]; then
        dpkg -i "$deb_path"
    else
        echo "Error: File $deb_pkg does not exist."
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
        TIDL_PROTOBUF_PATH=${WORK_DIR}/workarea/protobuf-${protobuf_ver} \
        GCC_LINUX_ARM_ROOT=/usr \
        TARGET_SOC=${platform} \
        CROSS_COMPILE_LINARO= \
        LINUX_SYSROOT_ARM=${TARGET_FS} \
        TREAT_WARNINGS_AS_ERROR=0

    # uninstall vision-apps.deb package
    dpkg -r libti-vision-apps-${platform}

done

cd $current_dir
