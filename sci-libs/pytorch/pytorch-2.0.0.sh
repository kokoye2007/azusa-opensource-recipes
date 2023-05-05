#!/bin/sh
source ../../common/init.sh
inherit python

PYTHON_RESTRICT="$PYTHON_LATEST"

get https://github.com/pytorch/pytorch/releases/download/v${PV}/pytorch-v${PV}.tar.gz ${P}.tar.gz
acheck

importpkg sci-libs/caffe2

cd "${S}"

apatch \
        "${FILESDIR}"/0002-Don-t-build-libtorch-again-for-PyTorch-1.7.1.patch \
        "${FILESDIR}"/pytorch-1.9.0-Change-library-directory-according-to-CMake-build.patch \
        "${FILESDIR}"/${P}-global-dlopen.patch \
        "${FILESDIR}"/pytorch-1.7.1-torch_shm_manager.patch \
        "${FILESDIR}"/${PN}-1.13.0-setup.patch \
        "${FILESDIR}"/${P}-emptyso.patch \

# ???
sed -i -e "/BUILD_DIR/s|build|/pkg/main/sci-libs.caffe2.dev/|" tools/setup_helpers/env.py

export PYTORCH_BUILD_VERSION="${PV}"
export PYTORCH_BUILD_NUMBER=0
export USE_SYSTEM_LIBS=ON
export CMAKE_BUILD_DIR="${T}"
export BUILD_DIR=

pythonsetup
archive
