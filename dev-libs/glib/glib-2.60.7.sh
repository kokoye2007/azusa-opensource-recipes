#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/glib/2.60/${P}.tar.xz
acheck

cd "${T}"

export DESTDIR="${D}"

# configure & build
meson setup --buildtype release --strip --prefix /pkg/main/${PKG}.core.${PVRF} \
	--datadir /pkg/main/${PKG}.core.${PVRF}/share --default-library shared --backend ninja "${CHPATH}/${P}" .

ninja
ninja install

finalize
