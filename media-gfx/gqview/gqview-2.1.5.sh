#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/${PN}/${P}.tar.gz
acheck

cd "${P}"

apatch \
	"${FILESDIR}/${P}-windows.patch" \
	"${FILESDIR}/${P}-glibc.patch"

sed -i \
	-e '/^Encoding/d' \
	-e '/^Icon/s/\.png//' \
	-e '/^Categories/s/Application;//' \
	gqview.desktop

aautoreconf

doconf

make
make install DESTDIR="${D}"

finalize
