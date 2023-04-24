#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/${PN}/${PV%.*}/${P}.tar.xz
acheck

cd "${T}"

domeson -Dgtk=false -Dlibsysprof=true -Dsystemdunitdir="/pkg/main/${PKG}.core.${PVRF}/systemd" -Dhelp=true 

finalize
