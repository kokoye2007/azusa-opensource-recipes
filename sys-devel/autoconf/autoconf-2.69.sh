#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnu.org/pub/gnu/${PN}/${P}.tar.gz
acheck

cd "${T}"

export EMACS=no
doconf --program-suffix=-${PV}

make
make install DESTDIR="${D}"

for foo in autom4te autoconf autoheader autoreconf ifnames autoscan autoupdate; do
	ln -snfv "$foo-$PV" "${D}/pkg/main/${PKG}.core.${PVR}/bin/$foo"
done

finalize
