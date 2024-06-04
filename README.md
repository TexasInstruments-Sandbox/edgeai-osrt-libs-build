Open-Source Runtime Library Build in Target Docker Container
============================================================

This build system covers building *ONNX-RT*, *FTLite-RT*, and *NEO-AI-DLR* from source for Ubuntu/Debian Docker container. Tested with PSDK 9.2 release in aarch64 Ubuntu 22.04 container. For other PSDK release, patches and settings might be updated.

Supported use cases include:

- **Case 1**: Compiling with the native GCC in arm64v8 Ubuntu Docker container directly on aarch64 build machine
- **Case 2**: Compiling with the native GCC in arm64v8 Ubuntu Docker container on x86_64 machine using QEMU

<!-- ### Build DL Runtime using QEMU on PC
![](docs/dlrt_build_qemu.svg)

### Build & Run Apps in Target Docker Container: To be covered in Edge AI / Robotics SDK
![](docs/target_docker.svg) -->

<!-- ======================================= -->
## Prerequisite

### docker-pull the base Docker image

Pull the baseline Docker image needed. Assuming outside of a proxy network,
```bash
docker pull arm64v8/ubuntu:22.04
docker pull arm64v8/ubuntu:20.04
docker pull arm64v8/debian:12.5
```

### edgeai-ti-proxy

Set up `edgeai-ti-proxy` ([repo link](https://bitbucket.itg.ti.com/projects/PROCESSOR-SDK-VISION/repos/edgeai-ti-proxy/browse))

Before docker-build or docker-run, please make sure sourcing `edgeai-ti-proxy/setup_proxy.sh`, which will define the `USE_PROXY` env variable and all the proxy settings for the TI network.

### (Only for Case 2) Initialize QEMU to Emulate ARM Architecture on x86 Ubuntu PC
If QEMU was not installed on the build Ubuntu PC,

```bash
sudo apt-get install -y qemu-user-static
# to initialize the QENU
./qemu_init.sh
```

## Docker Environment for Building

### Docker-build
```bash
BASE_IMAGE=ubuntu:22.04 ./docker_build.sh
```

### Docker-run
```bash
BASE_IMAGE=ubuntu:22.04 ./docker_run.sh
```

<!-- ======================================= -->
## Build ONNX-RT from Source

All the commends below should be run **in the Docker container**.

### Prepare the source and update the build config

Update `PROTOBUF_VER` in `onnxrt_prepare.sh` by, e.g., checking "`git log`" at `onnxruntime/cmake/external/protoc`. Currently it is set:
`PROTOBUF_VER=3.20.2`.


You can run the following in the Docker container for downloading source from git repo, applying patches, and downloading pre-built `protobuf`:
```bash
./onnxrt_prepare.sh
```

### Build
Update `PROTOBUF_VER` to match to the setting in `onnxrt_prepare.sh`. The following should be run in the Docker container with QEMU.

(Optional) To build `protobuf` from source, run the following inside the container.
```bash
./onnxrt_protobuf_build.sh
```

Update "`--path_to_protoc_exe`" in `onnxrt_build.sh` accordingly. To build ONNX-RT, run the following inside the container,
```bash
./onnxrt_build.sh
```

Outputs:
- Shared lib: `$WORK_DIR/workarea/onnxruntime/build/Linux/Release/libonnxruntime.so.1.14.0`
- Wheel file: `$WORK_DIR/workarea/onnxruntime/build/Linux/Release/dist/onnxruntime_tidl-1.14.0-cp36-cp36m-linux_aarch64.whl`

### Package

```bash
./onnxrt_package.sh
```

Output tarball: `$WORK_DIR/workarea/onnx-1.14.0-ubuntu22_aarch64.tar.gz`

<!-- ======================================= -->
## Build TFLite-RT from Source

All the commends below should be run **in the Docker container**.

### Prepare the source and update the build config

```bash
./tflite_prepare.sh
```

### Build
```bash
./tflite_build.sh
```

To build the Python wheel package:
```bash
./tflite_whl_build.sh
```

Outputs:
- Static lib: `$WORK_DIR/workarea/tensorflow/tflite_build/libtensorflow-lite.a`
- Wheel file: `$WORK_DIR/workarea/tensorflow/tensorflow/lite/tools/pip_package/gen/tflite_pip/python3/dist/tflite_runtime-2.12.0-cp310-cp310-linux_aarch64.whl`

### Package

To package the resulting `.a` file and header files, you can use the following script:

```bash
./tflite_package.sh
```

Output tarball: `$WORK_DIR/workarea/tflite-2.12-ubuntu22_aarch64.tar.gz`

<!-- ======================================= -->
## Build Neo-AI-DLR from Source

All the commends below should be run **in the Docker container**.

### Prepare the source and update the build config

```bash
./dlr_prepare.sh
```

### Build

```bash
./dlr_build.sh
```

### Package

```bash
./dlr_package.sh
```

Output wheel package: `$WORK_DIR/workarea/neo-ai-dlr/python/dist/dlr-1.13.0-py3-none-any.whl`
