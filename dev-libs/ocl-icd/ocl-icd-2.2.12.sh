#!/bin/sh
source "../../common/init.sh"
inherit asciidoc

get https://github.com/OCL-dev/"${PN}"/archive/v"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${S}" || exit
aautoreconf

cd "${T}" || exit

doconf --enable-pthread-once

make
make install DESTDIR="${D}"

finalize
