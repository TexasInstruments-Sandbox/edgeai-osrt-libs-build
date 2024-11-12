#!/bin/bash

# GST version
gst_ver="1.20.7"
echo "gst_ver = $gst_ver"

# patches
repo_base_url="https://git.ti.com/cgit/arago-project/meta-arago/plain/meta-arago-extras/recipes-multimedia/gstreamer/gstreamer1.0-plugins-good"
repo_branch=kirkstone
patch_files=(
    "0001-Adding-support-for-raw10-raw12-and-raw16-bayer-formats.patch"
    "0002-Adding-support-for-bayer-formats-with-IR-component.patch"
    "0003-v4l2-Changes-for-DMA-Buf-import-j721s2.patch"
    "0004-v4l2-Give-preference-to-contiguous-format-if-support.patch"
    "0005-HACK-gstv4l2object-Increase-min-buffers-for-CSI-capt.patch"
)

# work folder
work_dir="$WORK_DIR/workarea"
mkdir -p "$work_dir"
cd "$work_dir"

# Download the tarball
src_name="gst-plugins-good-${gst_ver}"
src_file="${src_name}.tar.xz"
src_url="https://gstreamer.freedesktop.org/src/gst-plugins-good/${src_file}"

if [ ! -d "$src_name" ]; then
    if wget "$src_url"; then
        tar xJf "$src_file"
        rm "$src_file"
    else
        echo "Download failed: $src_url"
        exit 1
    fi
else
    echo "$src_name already exist."
fi

# Apply patches
cd "$src_name"
for patch_file in "${patch_files[@]}"; do
    patch_url="${repo_base_url}/${patch_file}?h=${repo_branch}"

    if wget -O "$patch_file" "$patch_url"; then
        if patch -p1 < "$patch_file"; then
            echo "$patch_file applied successfully"
        else
            echo "Applying $patch_file failed"
            exit 1
        fi
    else
        echo "Download failed: $patch_file"
        exit 1
    fi
done

# Build
meson build
ninja -C build

# Update the gst v4l2 library
cp "${work_dir}/${src_name}/build/sys/v4l2/libgstvideo4linux2.so" "$work_dir"

# chmod
chmod -R a+w $WORK_DIR/workarea

echo "$(basename "$0"): Completed!"
