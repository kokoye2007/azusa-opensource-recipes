#!/bin/sh
source "../../common/init.sh"

get https://dist.libuv.org/dist/v"${PV}"/libuv-v"${PV}".tar.gz
acheck

cd "libuv-v${PV}" || exit

sh autogen.sh

cd "${T}" || exit

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
