#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/${PN}/${P}-src.tar.gz
acheck

importpkg dev-libs/openssl

cd */

doconflight --disable-openssl-runtime --disable-static --enable-lib-shared --enable-gettext --enable-openssl  --extra-cflags="$CPPFLAGS" --extra-ldflags="$LDFLAGS"

make
make install{,-lib-headers,-pkg-config} install-lib-so-link DESTDIR="${D}"

finalize
