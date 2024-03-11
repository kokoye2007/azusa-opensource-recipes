#!/bin/sh
source "../../common/init.sh"
inherit python

get https://github.com/davisking/dlib/archive/refs/tags/v${PV}.tar.gz $P.tar.gz
acheck

cd "${T}"

importpkg X
#importpkg dev-util/nvidia-cuda-toolkit dev-libs/cudnn X

# somehow fails with cuda
docmake -DDLIB_LINK_WITH_SQLITE3=ON -DDLIB_USE_CUDA=OFF

cd "$S"
pythonsetup

finalize
