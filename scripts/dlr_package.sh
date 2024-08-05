#! /bin/bash
set -e
if [ ! -f /.dockerenv ]; then
    echo "This script should be run inside the osrt-build Docker container"
    exit 1
fi

current_dir=$(pwd)

cd $WORK_DIR/workarea/neo-ai-dlr/python

# package
python3 ./setup.py bdist_wheel
ls dist

cd $current_dir

echo "dlr_package.sh: Completed!"
