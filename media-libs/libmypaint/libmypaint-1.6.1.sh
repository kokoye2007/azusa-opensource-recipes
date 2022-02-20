#!/bin/sh
source "../../common/init.sh"

MY_PV=${PV/_beta/-beta.}
MY_P=${PN}-${MY_PV}

get https://github.com/mypaint/libmypaint/releases/download/v${MY_PV}/${MY_P}.tar.xz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
