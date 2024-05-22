#! /bin/bash
current_dir=$(pwd)

# git clone
REPO_BRANCH="tidl-j7-2.12-latest"
REPO_TAG="a5870206f0c6addcb327b6095baab16639c1bd5c"
cd $WORK_DIR/workarea
git clone https://github.com/TexasInstruments/tensorflow.git --branch $REPO_BRANCH --single-branch tensorflow
cd tensorflow
git checkout $REPO_TAG

cd $current_dir
