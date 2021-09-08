#! /bin/bash
## Robotics SDK 0.5 release: package into a tarball
REL_VER="8.0"
DST_DIR=dlrt-libs-aarch64-ubuntu18.04
TARBALL=${DST_DIR}_${REL_VER}.tar.gz

# mkdir
mkdir -p $DST_DIR
rm $DST_DIR/*.so* rm $DST_DIR/*.a

# ONNX
LIB_DIR=./onnxruntime/build/Linux/Release
cp $LIB_DIR/libonnxruntime.so.1.7.0 $DST_DIR

# Tensorflow
LIB_DIR=./tensorflow/tensorflow/lite/tools/make/gen/linux_aarch64/lib/
cp $LIB_DIR/libtensorflow-lite.a $DST_DIR

# make tarball
tar czvf $TARBALL $DST_DIR
mkdir -p tarballs
mv $TARBALL tarballs
