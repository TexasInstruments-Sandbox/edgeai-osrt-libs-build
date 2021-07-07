#! /bin/bash
## scp from PC to J7 target
J7_IP_ADDR=192.168.1.32
SRC_DIR=./tensorflow/lite/tools/make/gen/linux_aarch64/lib/
ssh $J7_IP_ADDR 'mkdir -p /home/root/dlrt-build/tflite'
scp $SRC_DIR/libtensorflow-lite.a root@$J7_IP_ADDR:/home/root/dlrt-build/tflite