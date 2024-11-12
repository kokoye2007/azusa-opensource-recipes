#!/bin/sh
source "../../common/init.sh"

get https://sourceware.org/ftp/docbook-tools/new-trials/SOURCES/"${P}".tgz

cd "${P}" || exit

patch -p1 <"$FILESDIR/sgml-common-0.6.3-manpage-1.patch"
autoreconf -f -i

#cd "${T}"

doconf --sysconfdir=/etc

make
make install DESTDIR="${D}"

finalize
