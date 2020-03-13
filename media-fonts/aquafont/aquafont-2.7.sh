#!/bin/sh
source "../../common/init.sh"

MY_P="${PN/font/}${PV/\./_}"
get http://www.geocities.jp/teardrops_in_aquablue/fnt/${MY_P}.zip
acheck

cd "${T}"

doconf --localstatedir=/var

make
make install DESTDIR="${D}"

finalize
