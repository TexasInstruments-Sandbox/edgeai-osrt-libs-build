SET(CMAKE_SYSTEM_NAME Linux)
SET(CMAKE_SYSTEM_PROCESSOR aarch64)
SET(CMAKE_SYSTEM_VERSION 1)
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# Set the gcc and g++ toolchain
SET(sdk_path /home/abhay/ti-firmware-builder-j721s2-evm-10_01_00_01)
SET(CMAKE_C_COMPILER  ${sdk_path}/toolchain/sysroots/x86_64-arago-linux/usr/bin/aarch64-oe-linux/aarch64-oe-linux-gcc)
SET(CMAKE_CXX_COMPILER  ${sdk_path}/toolchain/sysroots/x86_64-arago-linux/usr/bin/aarch64-oe-linux/aarch64-oe-linux-g++)
SET(CMAKE_SYSROOT ${sdk_path}/targetfs)
include_directories (${sdk_path}/targetfs/usr/lib/python3.12/site-packages/numpy/core/include)
