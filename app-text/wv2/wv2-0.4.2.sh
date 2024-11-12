#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/wvware/"${P}".tar.bz2
acheck

cd "${T}" || exit

importpkg sys-libs/glibc sys-libs/zlib libxml-2.0

docmake

make
make install DESTDIR="${D}"

finalize
