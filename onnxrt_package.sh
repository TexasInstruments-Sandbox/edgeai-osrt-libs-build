#! /bin/bash
## package into a tarball
LIB_DIR=./onnxruntime/build/Linux/Release
INCLUDE_DIR=./onnxruntime/include
DST_DIR=onnxruntime-aarch64-ubuntu18.04
rm -rf $DST_DIR
mkdir $DST_DIR
cp $LIB_DIR/libonnxruntime.so.1.7.0 $DST_DIR
cp $LIB_DIR/dist/onnxruntime_tidl-1.7.0-cp36-cp36m-linux_aarch64.whl $DST_DIR
cp -r $INCLUDE_DIR $DST_DIR
tar czvf $DST_DIR.tar.gz $DST_DIR
