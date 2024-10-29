#! /bin/bash
# This script is expected to run inside the CONTAINER
source ${WORK_DIR}/scripts/utils.sh

if [ ! -f /.dockerenv ]; then
    echo "This script should be run inside the osrt-build Docker container"
    exit 1
fi

current_dir=$(pwd)

cd $WORK_DIR/workarea

## package into a tarball
onnx_ver=$(get_yaml_value "onnxruntime" "onnx_ver")
tidl_ver=$(get_yaml_value "onnxruntime" "tidl_ver")
pkg_dist=${BASE_IMAGE//:/}
DST_DIR="onnx-${onnx_ver}+${tidl_ver}-${pkg_dist}_aarch64"
LIB_DIR="onnxruntime/build/Linux/Release"
TARBALL="${DST_DIR}.tar.gz"

rm -rf "$DST_DIR"
mkdir -p "${DST_DIR}/onnxruntime"

# package .so
src_lib_file="${LIB_DIR}/libonnxruntime.so.${onnx_ver}+${tidl_ver}"
if [ -f "$src_lib_file" ]; then
    cp "$src_lib_file" "$DST_DIR"
else
    echo "Error: $src_lib_file does not exist"
    exit 1
fi

# package header files in an entire nested directory keeping the same hierarchy
# TODO: package only necessary header files for ONNX-RT
cd "${WORK_DIR}/workarea"
(cd ./onnxruntime && find . -name '*.h' -print | tar --create --files-from -) | (cd $DST_DIR/onnxruntime && tar xvfp -)

# make the tarball
cd "${WORK_DIR}/workarea"
if [ -z "$TARBALL" ]; then
    rm "$TARBALL"
fi
tar czf $TARBALL $DST_DIR
rm -rf $DST_DIR

# copy whl package
cd "${WORK_DIR}/workarea"
whl_path=$(find onnxruntime/build/Linux/Release/dist -name "onnxruntime_tidl-*.whl" || { echo "onnxruntime_tidl wheel package not found."; exit 1; })
cp $whl_path .

# chmod
chmod -R a+w $WORK_DIR/workarea

cd $current_dir

echo "$(basename $0): Completed!"
