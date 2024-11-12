#!/bin/sh
source "../../common/init.sh"

get https://github.com/apple/cups/releases/download/v"${PV}"/"${P}"-source.tar.gz
acheck

cd "${P}" || exit

sed -i 's:444:644:' Makedefs.in
sed 's#^.SILENT:##g' -i Makedefs.in
sed -i '/stat.h/a #include <asm-generic/ioctls.h>' tools/ipptool.c

#cd "${T}"

export CC=gcc CXX=g++

importpkg net-dns/avahi

AT_M4DIR=config-scripts aclocal
autoconf

doconf --disable-systemd --with-rcdir=/tmp/cupsinit # --with-system-groups=lpadmin

make
make install DESTDIR="${D}"

finalize
