#!/bin/sh
source "../../common/init.sh"

MY_PV=${PV/./-}
MY_P=${PN}-${MY_PV}
get https://thrysoee.dk/editline/${MY_P}.tar.gz
acheck

PATCHES=(
	"${FILESDIR}/${PN}-20170329.3.1-tinfo.patch"
)

cd "$MY_P"
apatch "${PATCHES[@]}"
aautoreconf

cd "${T}"

importpkg tinfo

importpkg zlib

doconf --enable-widec --enable-fast-install

make
make install DESTDIR="${D}"

finalize
