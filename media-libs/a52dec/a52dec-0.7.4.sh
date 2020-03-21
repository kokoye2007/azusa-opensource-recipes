#!/bin/sh
source "../../common/init.sh"
inherit libs

get http://liba52.sourceforge.net/files/${P}.tar.gz
acheck

cd "${S}"

apatch \
	"${FILESDIR}"/${P}-build.patch \
	"${FILESDIR}"/${P}-freebsd.patch \
	"${FILESDIR}"/${P}-tests-optional.patch \
	"${FILESDIR}"/${P}-test-hidden-symbols.patch

aautoreconf

cd "${T}"

preplib

importpkg sci-libs/djbfft

doconflight --enable-shared --disable-static --enable-djbfft

make
make install DESTDIR="${D}"

finalize
