#!/bin/sh
source "../../common/init.sh"

get http://ftp.debian.org/debian/pool/main/w/whois/whois_${PV}.tar.xz
acheck

cd "whois"

sed -i -e 's:#\(.*pos\):\1:' Makefile # nls

export HAVE_ICONV=1

make
make install BASEDIR="${D}" prefix="/pkg/main/${PKG}.core.${PVR}"

mkdir -p "${D}/pkg/main/${PKG}.core.${PVR}/etc"
cp -v whois.conf "${D}/pkg/main/${PKG}.core.${PVR}/etc"

finalize
