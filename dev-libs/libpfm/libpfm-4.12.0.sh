#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/"${PN}"4/"${P}".tar.gz
acheck

cd "${S}" || exit

PREFIX="/pkg/main/${PKG}.core.${PVRF}"
sed -e "s:SLDFLAGS=:SLDFLAGS=\$(LDFLAGS) :g" \
	-i lib/Makefile
sed -e "s:LIBDIR=\$(PREFIX)/lib:LIBDIR=\$(PREFIX)/$(get_libdir):g" \
	-i config.mk

make
make install DESTDIR="${D}" PREFIX="${PREFIX}"

finalize
