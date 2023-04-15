#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnu.org/pub/gnu/${PN}/${P}.tar.xz
acheck

cd "${T}"

doconf --with-readline=`realpath /pkg/main/sys-libs.readline.dev` --with-mpfr=`realpath /pkg/main/dev-libs.mpfr.dev`

make
make install DESTDIR="${D}"

finalize
