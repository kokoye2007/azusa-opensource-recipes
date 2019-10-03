#!/bin/sh
source "../../common/init.sh"

get http://fcron.free.fr/archives/${P}.src.tar.gz
acheck

cd "${T}"

doconf --without-sendmail --with-boot-install=no --with-systemdsystemunitdir=no --with-editor=/bin/vim --with-groupname=cron

make
make install DESTDIR="${D}"

finalize
