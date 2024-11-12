#!/bin/sh
source ../../common/init.sh
inherit python

PYTHON_RESTRICT="$PYTHON_LATEST"

get https://github.com/pytorch/pytorch/releases/download/v"${PV}"/pytorch-v"${PV}".tar.gz "${P}".tar.gz
acheck

importpkg sci-libs/caffe2

cd "${S}" || exit

apatch \
	"${FILESDIR}"/pytorch-2.2.1-Don-t-build-libtorch-again.patch \
        "${FILESDIR}"/pytorch-1.9.0-Change-library-directory-according-to-CMake-build.patch \
        "${FILESDIR}"/pytorch-2.0.0-global-dlopen.patch \
        "${FILESDIR}"/pytorch-1.7.1-torch_shm_manager.patch \
        "${FILESDIR}"/"${PN}"-1.13.0-setup.patch

sed -i -e "/BUILD_DIR/s|build|/pkg/main/sci-libs.caffe2.dev.${PV}/torch_build/|" tools/setup_helpers/env.py

export PYTORCH_BUILD_VERSION="${PV}"
export PYTORCH_BUILD_NUMBER=0
export USE_SYSTEM_LIBS=ON
export CMAKE_BUILD_DIR="${T}"
export BUILD_DIR=

pythonsetup

# copy version.py
cp -v "/pkg/main/sci-libs.caffe2.dev.${PV}/torch_build/version.py" "${D}/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_RESTRICT}.${OS}.${ARCH}/lib/python${PYTHON_RESTRICT%.*}/site-packages/torch/version.py"

# create symlink to caffe2
# -I/pkg/main/sci-libs.pytorch.mod.2.2.1.py3.12.2.linux.amd64/lib/python3.12/site-packages/torch/include/torch/csrc/api/include
ln -snfv $(realpath /pkg/main/sci-libs.caffe2.dev/include) $(echo "${D}"/pkg/main/"${PKG}".mod.*/lib/python*/site-packages/torch)/include

archive
