#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/${PN}/${PV%.*}/${P}.tar.xz
acheck

cd "${T}"

# TODO: eventially enable doc once we have docbook

# configure & build
meson setup --buildtype release --strip --prefix /pkg/main/${PKG}.core.${PVRF} \
	--datadir /pkg/main/${PKG}.core.${PVRF}/share --default-library shared -Dselinux=disabled "${CHPATH}/${P}" .

ninja
DESTDIR="${D}" ninja install

finalize
