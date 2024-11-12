#!/bin/sh
source "../../common/init.sh"

get https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/mp4v2/mp4v2-"${PV}".tar.bz2
acheck

cd "${S}" || exit

PATCHES=(
    "${FILESDIR}/${P}-gcc7.patch"
    "${FILESDIR}/${P}-mp4tags-corruption.patch"
    "${FILESDIR}/${P}-clang.patch"
    "${FILESDIR}/${P}-CVE-2018-14054.patch"
    "${FILESDIR}/${P}-CVE-2018-14325.patch"
    "${FILESDIR}/${P}-CVE-2018-14379.patch"
    "${FILESDIR}/${P}-CVE-2018-14403.patch"
    "${FILESDIR}/${P}-unsigned-int-cast.patch"
)

apatch "${PATCHES[@]}"

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
