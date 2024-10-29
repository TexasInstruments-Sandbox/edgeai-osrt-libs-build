#! /bin/bash
# This script is expected to run inside the CONTAINER
source ${WORK_DIR}/scripts/utils.sh

if [ ! -f /.dockerenv ]; then
    echo "This script should be run inside the osrt-build Docker container"
    exit 1
fi

current_dir=$(pwd)
cd $WORK_DIR/workarea

# base_image 
base_image=${BASE_IMAGE//:/}

# target platforms
platforms=("j784s4" "j721s2" "j721e" "j722s" "am62a")
mpus=("A72" "A72" "A72" "A53" "A53")

# collect the TIDL modules
copy_lib_files() {
    local target_dir=$1
    shift
    local lib_files=("$@")

    mkdir -p "$target_dir"
    for lib_file in "${lib_files[@]}"; do
        if [ -f "$lib_file" ]; then
            cp "$lib_file" "$target_dir"
        else
            echo "Error: File $lib_file does not exist."
            exit 1
        fi
    done
}

# package the libs into a tarball
for i in "${!platforms[@]}"; do
    platform=${platforms[$i]}
    mpu=${mpus[$i]}

    DST_DIR="arm-tidl-${platform}_${SDK_VER}-${base_image}"
    TARBALL="${DST_DIR}.tar.gz"

    tidl_lib_files=(
        "arm-tidl/rt/out/${platform^^}/${mpu}/LINUX/release/libvx_tidl_rt.so.1.0"
        "arm-tidl/onnxrt_ep/out/${platform^^}/${mpu}/LINUX/release/libtidl_onnxrt_EP.so.1.0"
        "arm-tidl/tfl_delegate/out/${platform^^}/${mpu}/LINUX/release/libtidl_tfl_delegate.so.1.0"
    )

    rm -rf $DST_DIR
    mkdir -p $DST_DIR
    copy_lib_files "$DST_DIR" "${tidl_lib_files[@]}"

    # make the tarball
    if [ -z "$TARBALL" ]; then
        rm "$TARBALL"
    fi
    tar czf $TARBALL $DST_DIR
    rm -rf $DST_DIR

done

# chmod
chmod -R a+w $WORK_DIR/workarea

cd $current_dir

echo "$(basename $0): Completed!"
