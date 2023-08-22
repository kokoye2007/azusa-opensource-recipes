#!/bin/sh
source "../../common/init.sh"

MY_PN="${PN%-c}"
get https://github.com/${MY_PN}/${MY_PN}3/archive/${PV}.tar.gz ${MY_PN}-${PV}.tar.gz
acheck

S="${S}/runtime/C"

cd "${S}"

aautoreconf

#cd "${T}"

doconf --enable-64bit

make
make install DESTDIR="${D}"

finalize
