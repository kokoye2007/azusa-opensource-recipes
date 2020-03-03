#!/bin/sh
source "../../common/init.sh"

get https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz
acheck

cd "${T}"

docmake -DUSE_SSH=ON -DTHREADSAFE=ON -DUSE_HTTPS=ON -DBUILD_CLAR=OFF -DUSE_EXT_HTTP_PARSER=ON -DUSE_BUNDLED_ZLIB=OFF

make
make install DESTDIR="${D}"

finalize
