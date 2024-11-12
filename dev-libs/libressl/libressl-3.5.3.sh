#!/bin/sh
source "../../common/init.sh"

get https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/"${P}".tar.gz
acheck

cd "${P}" || exit

importpkg zlib

doconf --enable-nc

make
make install MANSUFFIX=ssl DESTDIR="${D}"

finalize
