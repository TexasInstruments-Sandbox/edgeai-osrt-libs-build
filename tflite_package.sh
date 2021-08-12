#! /bin/bash
## package into a tarball
TIDL_VER="tidl8.0.0"
LIB_DIR=./tensorflow/tensorflow/lite/tools/make/gen/linux_aarch64/lib/
INCLUDE_DIR=./tensorflow/tensorflow/lite/tools/make/downloads/flatbuffers/include
DST_DIR=tensorflow-aarch64-ubuntu18.04
rm -rf $DST_DIR
mkdir -p $DST_DIR
cp $LIB_DIR/libtensorflow-lite.a $DST_DIR
cp -r $INCLUDE_DIR $DST_DIR
tar czvf $DST_DIR-$TIDL_VER.tar.gz $DST_DIR
