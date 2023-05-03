#!/bin/sh
source "../../common/init.sh"

get https://github.com/protocolbuffers/${PN}/archive/v${PV}.tar.gz
acheck

cd */

aautoreconf

cd "${T}"

importpkg zlib

doconf

make -j$NPROC
make install DESTDIR="${D}"

finalize
