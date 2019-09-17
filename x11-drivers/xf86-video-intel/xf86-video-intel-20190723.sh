#!/bin/sh
source "../../common/init.sh"

get http://anduin.linuxfromscratch.org/BLFS/${PN}/${P}.tar.xz

cd "${P}"

autoreconf -v --install

cd "${T}"

doconf --localstatedir=/var --enable-kms-only --enable-uxa

make
make install DESTDIR="${D}"

finalize
