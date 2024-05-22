#! /bin/bash
current_dir=$(pwd)

cd $WORK_DIR/workarea

## package into a tarball
TIDL_VER="tidl9.2.0"
LIB_DIR=./onnxruntime/build/Linux/Release
INCLUDE_DIR=./onnxruntime/include
DST_DIR=onnxruntime-aarch64-ubuntu22.04
TARBALL=$DST_DIR-$TIDL_VER.tar.gz
rm -rf $DST_DIR
mkdir -p $DST_DIR
cp $LIB_DIR/libonnxruntime.so.1.14.0 $DST_DIR
cp $LIB_DIR/dist/onnxruntime_tidl-1.14.0-cp38-cp38-linux_aarch64.whl $DST_DIR
cp -r $INCLUDE_DIR $DST_DIR
tar czvf $TARBALL $DST_DIR
mkdir -p tarballs
mv $TARBALL tarballs

cd $current_dir