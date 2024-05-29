#! /bin/bash
# This script is expected to run inside the CONTAINER
current_dir=$(pwd)

cd $WORK_DIR/workarea

## package into a tarball
DST_DIR=$WORK_DIR/workarea/tensorflow-2.12-ubuntu22_aarch64
LIB_DIR=$WORK_DIR/workarea/tensorflow/tflite_build/
TARBALL=$DST_DIR.tar.gz

rm -rf $DST_DIR
mkdir -p $DST_DIR/tflite_2.12
mkdir -p $DST_DIR/tensorflow/third_party
mkdir -p $DST_DIR/tensorflow/tensorflow/lite

# package .a
cp $LIB_DIR/libtensorflow-lite.a $DST_DIR

# package dependency .a files
(cd $LIB_DIR/_deps && find . -name '*.a' -print | tar --create --files-from -) | (cd $DST_DIR/tflite_2.12 && tar xvfp -)

# make each package folder flat
for dir in $DST_DIR/tflite_2.12/*; do
    if [ -d "$dir" ]; then
        cd "$dir"
        find . -name "*.a" -exec mv {} . \;
    fi
done

# package header files in an entire nested directory keeping the same hierarchy
cd $WORK_DIR/workarea
(cd ./tensorflow/third_party && find . -name '*.h' -print | tar --create --files-from -) | (cd $DST_DIR/tensorflow/third_party && tar xvfp -)
(cd ./tensorflow/tensorflow/lite && find . -name '*.h' -print | tar --create --files-from -) | (cd $DST_DIR/tensorflow/tensorflow/lite && tar xvfp -)

# make the tarball
if [ -z "$TARBALL" ]; then
    rm "$TARBALL"
fi
tar czf $TARBALL $DST_DIR
rm -rf $DST_DIR

cd $current_dir

echo "tflite_package.sh: Completed!"
