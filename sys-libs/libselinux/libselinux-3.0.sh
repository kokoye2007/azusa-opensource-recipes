#!/bin/sh
source "../../common/init.sh"

get https://github.com/SELinuxProject/selinux/releases/download/20191204/${P}.tar.gz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
