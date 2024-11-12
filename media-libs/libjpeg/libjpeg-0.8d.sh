#!/bin/sh
source "../../common/init.sh"

get https://archive.debian.org/debian/pool/main/libj/libjpeg8/libjpeg8_8d.orig.tar.gz
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
