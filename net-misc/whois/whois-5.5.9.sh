#!/bin/sh
source "../../common/init.sh"

get https://github.com/rfc1036/"${PN}"/archive/v"${PV}".tar.gz
acheck

cd "${S}" || exit

sed -i -e 's:#\(.*pos\):\1:' Makefile # nls

export HAVE_ICONV=1

make
make install BASEDIR="${D}" prefix="/pkg/main/${PKG}.core.${PVRF}"

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/etc"
cp -v whois.conf "${D}/pkg/main/${PKG}.core.${PVRF}/etc"

finalize
