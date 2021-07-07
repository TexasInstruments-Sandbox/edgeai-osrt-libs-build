#! /bin/bash
## scp from PC to J7 target
J7_IP_ADDR=192.168.1.32
SRC_DIR=./onnxruntime/build/Linux/Release
ssh $J7_IP_ADDR 'mkdir -p /home/root/dlrt-build/onnxrt'
scp $BUILD_DIR/libonnxruntime.so.1.7.0 \
    $BUILD_DIR/dist/onnxruntime_tidl-1.7.0-cp36-cp36m-linux_aarch64.whl \
    root@$J7_IP_ADDR:/home/root/dlrt-build/onnxrt