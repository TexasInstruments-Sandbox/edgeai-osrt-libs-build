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
TF_VER=$(get_yaml_value "tensorflow" "tf_ver")
PKG_DIST=${BASE_IMAGE//:/}
DST_DIR=tflite-${TF_VER}-${PKG_DIST}_aarch64
LIB_DIR=tensorflow/tflite_build
TARBALL=$DST_DIR.tar.gz

rm -rf $DST_DIR
mkdir -p $DST_DIR/tflite_${TF_VER}
mkdir -p $DST_DIR/tensorflow/third_party
mkdir -p $DST_DIR/tensorflow/tensorflow/lite

# package .a
cp $LIB_DIR/libtensorflow-lite.a $DST_DIR

# package dependency .a files
(cd $WORK_DIR/workarea/$LIB_DIR/_deps && find . -name '*.a' -print | tar --create --files-from -) | (cd $DST_DIR/tflite_2.12 && tar xvfp -)
(cd $WORK_DIR/workarea/$LIB_DIR && find pthreadpool -name '*.a' -print | tar --create --files-from -) | (cd $DST_DIR/tflite_2.12 && tar xvfp -)

# make each package folder flat
cd $WORK_DIR/workarea
for dir in $DST_DIR/tflite_${TF_VER}/*; do
    if [ -d "$dir" ]; then
        cd "$dir"
        find . -name "*.a" -exec mv {} . \;
        cd -
    fi
done

# package header files in an entire nested directory keeping the same hierarchy
(cd $WORK_DIR/workarea/tensorflow/third_party && find . -name '*.h' -print | tar --create --files-from -) | (cd $DST_DIR/tensorflow/third_party && tar xvfp -)
(cd $WORK_DIR/workarea/tensorflow/tensorflow/lite && find . -name '*.h' -print | tar --create --files-from -) | (cd $DST_DIR/tensorflow/tensorflow/lite && tar xvfp -)

# make the tarball
cd $WORK_DIR/workarea
if [ -z "$TARBALL" ]; then
    rm "$TARBALL"
fi
tar czf $TARBALL $DST_DIR
rm -rf $DST_DIR

# copy whl package
cd "${WORK_DIR}/workarea"
whl_path=$(find tensorflow/tensorflow/lite/tools/pip_package/gen/tflite_pip/python3/dist -name "tflite_runtime*.whl" || { echo "tflite_runtime whl not found."; exit 1; })
cp $whl_path .

cd $current_dir

echo "$(basename $0): Completed!"
