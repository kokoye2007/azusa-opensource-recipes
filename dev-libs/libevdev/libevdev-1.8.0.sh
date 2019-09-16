#!/bin/sh
source "../../common/init.sh"

get https://www.freedesktop.org/software/${PN}/${P}.tar.xz

cd "${T}"

doconf --localstatedir=/var

make
make install DESTDIR="${D}"

finalize
