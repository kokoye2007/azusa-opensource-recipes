#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/${PN}/${PV%.*}/${P}.tar.xz
acheck

cd "${T}"

# TODO: eventially enable doc once we have docbook

# configure & build
domeson --strip --default-library shared -Dselinux=disabled

finalize
