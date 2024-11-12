#!/bin/sh
source "../../common/init.sh"

get https://github.com/protocolbuffers/"${PN}"/archive/v"${PV}".tar.gz
acheck

cd */ || exit

aautoreconf

cd "${T}" || exit

importpkg zlib

doconf

make -j"$NPROC"
make install DESTDIR="${D}"

finalize
