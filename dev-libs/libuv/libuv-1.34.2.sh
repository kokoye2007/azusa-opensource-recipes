#!/bin/sh
source "../../common/init.sh"

get https://dist.libuv.org/dist/v${PV}/libuv-v${PV}.tar.gz
acheck

cd "libuv-v${PV}"

sh autogen.sh

cd "${T}"

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
