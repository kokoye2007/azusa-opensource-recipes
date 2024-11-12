#!/bin/sh
source "../../common/init.sh"

doget() {
	local CATEGORY=app-text
	local PN=texlive-core
	get ftp://tug.org/texlive/historic/"${PV:0:4}"/texlive-"${PV}"-source.tar.xz
}

doget
acheck

cd "texlive-${PV}-source/texk/kpathsea" || exit

doconf

make
make install DESTDIR="${D}"

finalize
