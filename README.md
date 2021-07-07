QEMU-based Build DL Runtime for J7 Target Docker Containers
===========================================================

Currently covers ONNX-RT and FTLite for Ubuntu 18.04 Docker container.

![](docs/dlrt_build_qemu.svg)

## Clone This GIT repo
```
git clone <this_repo_url>
cd dlrt-build
WORK_DIR=$(pwd)
```


After pulling the source (see below), the folder structure looks like below:
```
.
├── docker
│   ├── docker_build.sh
│   ├── Dockerfile-arm64v8-ubuntu18-py36-gcc9
│   ├── docker_run.sh
│   ├── entrypoint.sh
│   └── setup_proxy.sh
├── docs
│   └── dlrt_build_qemu.svg
├── onnxruntime_          # ONNX-RT source folder
├── tensorflow            # Tensorflow source folder
├── patches
│   ├── onnxrt
│   └── tflite
├── README.md
├── qemu_init.sh
├── onnxrt_build.sh
├── onnxrt_deploy.sh
├── onnxrt_prepare.sh
├── onnxrt_protobuf_build.sh
├── tflite_build.sh
├── tflite_deploy.sh
└── tflite_prepare.sh
```

## Docker Environment for Building

### Initialize QEMU to emulate ARM architecture on x86 Ubuntu PC
```
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
```

### Build Docker Image for Building
```
cd $WORK_DIR/docker
./docker_build.sh
```

**Note**: The base Docker images `arm64v8/ubuntu:18.04` is NOT yet registered in the TI artifactory. So `docker_build.sh` does not work in TI network.

This will take several minutes. You can check the resulting docker images:
```
$ docker images
REPOSITORY                   TAG         IMAGE ID       CREATED             SIZE
arm64v8-ubuntu18-py36-gcc9   latest      6f545823db99   36 seconds ago      768MB
```

<!-- ### Start the Docker Container
```
cd $WORK_DIR/docker
./docker_run.sh
``` -->

<!-- ======================================= -->
## Build ONNX-RT from Source

### Prepare the source, apply the patch (Edge AI 0.5), update config
You can run this on the Ubuntu PC command-line.
```
cd $WORK_DIR
./onnxrt_prepare.sh
```

### Build
This should be run in the Docker container with QEMU.
```
cd $WORK_DIR/docker
./docker_run.sh
```

####  Build PROTOBUF
Inside the container:
```
./onnxrt_protobuf_build.sh
```

#### Build ONNX-RT
```
./onnxrt_build.sh
```

Outputs:
- Shared lib: `build/Linux/Release/libonnxruntime.so.1.7.0`
- Wheel file: `build/Linux/Release/dist/onnxruntime_tidl-1.7.0-cp36-cp36m-linux_aarch64.whl`


### Deploy to J7 target
Update `J7_IP_ADDR` in `onnxrt_deploy.sh`.

On the build Ubuntu PC command-line:
```
cd $WORK_DIR
./onnxrt_deploy.sh
```

<!-- ======================================= -->
## Build TFLite from Source

### Prepare the source, apply the patch (Edge AI 0.5), update config
You can run this on the Ubuntu PC command-line.
```
cd $WORK_DIR
./tflite_prepare.sh
```

### Build
This should be run in the Docker container with QEMU.
```
cd $WORK_DIR/docker
./docker_run.sh
```

#### Build TFLite
Inside the container:
```
./tflite_build.sh
```

Outputs:
- Static lib: `tensorflow/lite/tools/make/gen/linux_aarch64/lib/libtensorflow-lite.a`
- Wheel file: TODO

### Deploy to J7 target
Update `J7_IP_ADDR` in `tflite_deploy.sh`.

On the build Ubuntu PC command-line:
```
cd $WORK_DIR
./tflite_deploy.sh
```





