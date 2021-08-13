#! /bin/bash
## package into a tarball
TIDL_VER="tidl8.0.0"
LIB_DIR=./onnxruntime/build/Linux/Release
INCLUDE_DIR=./onnxruntime/include
DST_DIR=onnxruntime-aarch64-ubuntu18.04
TARBALL=$DST_DIR-$TIDL_VER.tar.gz
rm -rf $DST_DIR
mkdir -p $DST_DIR
cp $LIB_DIR/libonnxruntime.so.1.7.0 $DST_DIR
cp $LIB_DIR/dist/onnxruntime_tidl-1.7.0-cp36-cp36m-linux_aarch64.whl $DST_DIR
cp -r $INCLUDE_DIR $DST_DIR
tar czvf $TARBALL $DST_DIR
mkdir -p tarballs
mv $TARBALL tarballs
