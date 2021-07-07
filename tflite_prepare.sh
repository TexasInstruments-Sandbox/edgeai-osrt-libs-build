#! /bin/bash
git clone --single-branch -b r2.4 https://github.com/tensorflow/tensorflow.git tensorflow
cd tensorflow
git checkout -b tidl_branch 582c8d236cb079023657287c318ff26adb239002

# apply patch (Edge AI 0.5)
git am ../patches/tflite/0001-tflite-interpreter-add-support-for-custom-data.patch

# download dependencies
./tensorflow/lite/tools/make/download_dependencies.sh

# update build config: tensorflow/lite/tools/make/targets/aarch64_makefile.inc
# TARGET_TOOLCHAIN_PREFIX :=
cp ../patches/tflite/aarch64_makefile.inc ./tensorflow/lite/tools/make/targets/aarch64_makefile.inc
cd -