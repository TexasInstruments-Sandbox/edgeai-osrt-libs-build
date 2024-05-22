#!/bin/bash
# Prerequisite: QEMU packages should be installed using the following command
# sudo apt-get install qemu binfmt-support qemu-user-static
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes