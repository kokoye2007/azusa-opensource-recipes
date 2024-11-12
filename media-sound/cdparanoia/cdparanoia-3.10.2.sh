#!/bin/sh
source "../../common/init.sh"

MY_P="${PN}-III-10.2"
get http://downloads.xiph.org/releases/cdparanoia/"${MY_P}".src.tgz

cd "${MY_P}" || exit

get https://dev.gentoo.org/~ssuominen/"${MY_P}"-patches-2.tbz2
apatch patches/*.patch

acheck

mv configure.guess config.guess
mv configure.sub config.sub

sed -i -e '/configure.\(guess\|sub\)/d' configure.in

autoconf
libtoolize

#cd "${T}"

doconf

make OPT="-I${CHPATH}/${MY_P}/interface"
make install DESTDIR="${D}"

finalize
