#!/bin/sh
source "../../common/init.sh"

get https://github.com/${PN}/${PN}/archive/${PV}.tar.gz ${P}.tar.gz
acheck

cd "${T}"

importpkg zlib dev-libs/boost

docmake -DALEMBIC_BUILD_LIBS=ON -DALEMBIC_SHARED_LIBS=ON -DDOCS_PATH=OFF -DUSE_ARNOLD=OFF -DUSE_BINARIES=ON -DUSE_EXAMPLES=ON -DUSE_HDF5=ON -DUSE_MAYA=OFF -DUSE_PRMAN=OFF -DUSE_PYALEMBIC=OFF -DUSE_TESTS=OFF 
# -DPython3_EXECUTABLE=

finalize
