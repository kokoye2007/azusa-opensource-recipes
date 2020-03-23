#!/bin/sh
source "../../common/init.sh"

get http://ftp.jp.debian.org/debian/pool/main/d/${PN}/${PN}_${PV}.tar.gz
download http://ftp.jaist.ac.jp/pub/Linux/Gentoo/distfiles/devices.tar.gz
acheck

cd "${S}"

mkdir -p "${D}/pkg/main/${PKG}.core.${PVR}"
ln -snfTv . "${D}/pkg/main/${PKG}.core.${PVR}/usr"
ln -snfTv /pkg/main/${PKG}.data.${PVR} "${D}/pkg/main/${PKG}.core.${PVR}/debootstrap"

make install DESTDIR="${D}/pkg/main/${PKG}.core.${PVR}" DSDIR="${D}/pkg/main/${PKG}.data.${PVR}"

finalize
