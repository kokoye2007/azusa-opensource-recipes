#!/bin/sh
source "../../common/init.sh"

get http://fcron.free.fr/archives/"${P}".src.tar.gz
acheck

cd "${S}" || exit

sed -i -e '/LIBS/ s/CFLAGS/LDFLAGS/' Makefile.in

cd "${T}" || exit

importpkg sys-libs/libxcrypt

doconf --disable-checks --without-sendmail --with-boot-install=no --with-systemdsystemunitdir=no --with-editor=/bin/vim --with-username=cron --with-groupname=cron --with-rootname=root --with-rootgroup=root

make
make install DESTDIR="${D}"

finalize
