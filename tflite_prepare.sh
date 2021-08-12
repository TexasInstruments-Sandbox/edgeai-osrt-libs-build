#! /bin/bash
REPO_BRANCH="tidl-j7"
REPO_TAG="TIDL_PSDK_8.0"
git clone https://github.com/TexasInstruments/tensorflow.git --branch $REPO_BRANCH --single-branch tensorflow
cd tensorflow

# download dependencies
./tensorflow/lite/tools/make/download_dependencies.sh

# update build config: tensorflow/lite/tools/make/targets/aarch64_makefile.inc
# TARGET_TOOLCHAIN_PREFIX :=
cp ../patches/tflite/aarch64_makefile.inc ./tensorflow/lite/tools/make/targets/aarch64_makefile.inc
cd -
