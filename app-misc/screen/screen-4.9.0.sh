#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/"${PN}"/"${P}".tar.gz
acheck

cd "${S}" || exit

aautoreconf

#cd "${T}"

importpkg tinfo libxcrypt

doconf --with-socket-dir=/var/run/screen --with-pty-group=5 --with-sys-screenrc=/etc/screenrc

sed -i -e "s%/usr/local/etc/screenrc%/etc/screenrc%" {etc,doc}/*

make
make install DESTDIR="${D}"

finalize
