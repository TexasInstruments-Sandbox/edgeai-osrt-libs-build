#! /bin/bash
## scp from PC to J7 target
J7_IP_ADDR=192.168.1.32
SRC_DIR=./tensorflow/tensorflow/lite/tools/make/gen/linux_aarch64/lib/
DST_DIR=/home/root/dlrt-build/tflite
ssh $J7_IP_ADDR "rm -rf $DST_DIR"
ssh $J7_IP_ADDR "mkdir -p $DST_DIR"
scp $SRC_DIR/libtensorflow-lite.a root@$J7_IP_ADDR:$DST_DIR