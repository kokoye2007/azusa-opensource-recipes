#!/bin/sh
source "../../common/init.sh"

get https://nodejs.org/dist/v${PV}/node-v${PV}.tar.xz

cd "node-v${PV}"

doconflight --shared-cares --shared-libuv --shared-nghttp2 --shared-openssl --shared-zlib --with-intl=system-icu

make
make install DESTDIR="${D}"

finalize
