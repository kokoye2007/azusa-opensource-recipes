#!/bin/sh
source "../../common/init.sh"

MYPN=CoinMP

get http://www.coin-or.org/download/source/${MYPN}/${MYPN}-${PV}.tgz
acheck

cd "${S}"

sed -i \
	-e "s:lib/pkgconfig:lib$LIB_SUFFIX/pkgconfig:g" \
	configure
sed -i \
	-e '/^addlibsdir/s/$(DESTDIR)//' \
	-e 's/$(addlibsdir)/$(DESTDIR)\/$(addlibsdir)/g' \
	-e 's/$(DESTDIR)$(DESTDIR)/$(DESTDIR)/g' \
	Makefile.in

cd "${T}"

doconflight --enable-dependency-linking --with-coin-instdir="/pkg/main/${PKG}.core.${PVRF}" --datadir=/usr/share

make
make install DESTDIR="${D}"

finalize
