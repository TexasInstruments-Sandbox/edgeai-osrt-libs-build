#! /bin/bash
## scp from PC to J7 target
J7_IP_ADDR=192.168.1.32
SRC_DIR=./onnxruntime/build/Linux/Release
DST_DIR=/home/root/dlrt-build/onnxrt
ssh $J7_IP_ADDR "rm -rf $DST_DIR"
ssh $J7_IP_ADDR "mkdir -p $DST_DIR"
scp $BUILD_DIR/libonnxruntime.so.1.7.0 \
    $BUILD_DIR/dist/onnxruntime_tidl-1.7.0-cp36-cp36m-linux_aarch64.whl \
    root@$J7_IP_ADDR:$DST_DIR