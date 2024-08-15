#! /bin/bash
# This script is expected to run inside the CONTAINER
set -e
source utils.sh

if [ ! -f /.dockerenv ]; then
    echo "This script should be run inside the osrt-build Docker container"
    exit 1
fi

current_dir=$(pwd)

cd $WORK_DIR/workarea

## package into a tarball
ONNX_VER=$(get_yaml_value "onnxruntime" "onnx_ver")
TIDL_VER=$(get_yaml_value "onnxruntime" "tidl_ver")
PKG_DIST=${BASE_IMAGE//:/}
DST_DIR=onnx-${ONNX_VER}+${TIDL_VER}-${PKG_DIST}_aarch64
LIB_DIR=onnxruntime/build/Linux/Release
TARBALL=$DST_DIR.tar.gz

rm -rf "$DST_DIR"
mkdir -p "$DST_DIR/onnxruntime"

# package .so
cp "$LIB_DIR/libonnxruntime.so.${ONNX_VER}+${TIDL_VER} $DST_DIR"

# package header files in an entire nested directory keeping the same hierarchy
# TODO: package only necessary header files for ONNX-RT
cd $WORK_DIR/workarea
(cd ./onnxruntime && find . -name '*.h' -print | tar --create --files-from -) | (cd $DST_DIR/onnxruntime && tar xvfp -)

# make the tarball
cd $WORK_DIR/workarea
if [ -z "$TARBALL" ]; then
    rm "$TARBALL"
fi
tar czf $TARBALL $DST_DIR
rm -rf $DST_DIR

cd $current_dir

echo "onnxrt_package.sh: Completed!"
