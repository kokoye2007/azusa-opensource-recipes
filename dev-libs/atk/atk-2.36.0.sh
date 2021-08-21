#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/atk/${PV%.*}/${P}.tar.xz
acheck

cd "${T}"

domeson

ninja
DESTDIR="${D}" ninja install

finalize
