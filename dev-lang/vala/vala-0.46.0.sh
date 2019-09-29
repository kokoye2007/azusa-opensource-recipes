#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/vala/0.46/${P}.tar.xz
acheck

# vala requires libtool to be in /usr/lib64/libltdl.la - this should be configurable but doesn't seem to be the case
# so we force it manually
ln -snfv /pkg/main/sys-devel.libtool.libs/lib$LIB_SUFFIX/* /usr/lib$LIB_SUFFIX/

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
