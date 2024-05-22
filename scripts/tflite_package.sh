#! /bin/bash
current_dir=$(pwd)

cd $WORK_DIR/workarea

## package into a tarball
TIDL_VER="tidl9.2.0"
LIB_DIR=./tensorflow/tflite_build/
INCLUDE_DIR=./tensorflow/tensorflow/lite/tools/make/downloads/flatbuffers/include
DST_DIR=tensorflow-aarch64-ubuntu22.04
TARBALL=$DST_DIR-$TIDL_VER.tar.gz
rm -rf $DST_DIR
mkdir -p $DST_DIR
cp $LIB_DIR/libtensorflow-lite.a $DST_DIR
cp -r $INCLUDE_DIR $DST_DIR
tar czvf $TARBALL $DST_DIR
mkdir -p tarballs
mv $TARBALL tarballs

cd $current_dir
