#! /bin/bash
# This script should be run inside the CONTAINER
# ref: https://confluence.itg.ti.com/pages/viewpage.action?pageId=442411315
# TODO: check Yocto receipt for generating wheel file
# Output: <tensorflow_path>/tensorflow/lite/tools/make/gen/linux_aarch64/lib/libtensorflow-lite.a
cd tensorflow/tensorflow/lite/tools/make
./build_aarch64_lib.sh lib
cd -
