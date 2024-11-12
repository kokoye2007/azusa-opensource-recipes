#!/bin/sh
source "../../common/init.sh"

get http://caca.zoy.org/raw-attachment/wiki/"${PN}"/"${P}".tar.gz
acheck

cd "${P}" || exit

sed -i -e 's:-g -O2 -fno-strength-reduce -fomit-frame-pointer::' configure
sed -i -e 's:$(srcdir)/$^:$^:' doc/Makefile.in doc/Makefile.am

cd "${T}" || exit

importpkg zlib

doconf

make
make install DESTDIR="${D}"

finalize
