#!/bin/sh
source "../../common/init.sh"

get https://download.qt.io/official_releases/qt/${PV%.*}/${PV}/submodules/${PN}-everywhere-src-${PV}.tar.xz

cd "${T}"

importpkg zlib icu-uc libpcre2-8

callconf -prefix "/pkg/main/${PKG}.core.${PVR}" -extprefix "${D}/pkg/main/${PKG}.core.${PVR}" -no-feature-statx -opensource -confirm-license -release -shared -pkg-config -no-gui -no-widgets -no-dbus --doubleconversion=system -glib -icu --pcre=system --zlib=system -ssl -openssl-linked --sqlite=system

make
make install DESTDIR="${D}"

finalize
