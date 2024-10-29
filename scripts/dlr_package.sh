#! /bin/bash
if [ ! -f /.dockerenv ]; then
    echo "This script should be run inside the osrt-build Docker container"
    exit 1
fi

current_dir=$(pwd)

cd $WORK_DIR/workarea/neo-ai-dlr/python

# package
python3 ./setup.py bdist_wheel
ls dist

# copy whl package
cd "${WORK_DIR}/workarea"
whl_path=$(find neo-ai-dlr/python/dist -name "dlr-*.whl" || { echo "dlr wheel package not found."; exit 1; })
cp $whl_path .

# chmod
chmod -R a+w $WORK_DIR/workarea

cd $current_dir

echo "$(basename $0): Completed!"
