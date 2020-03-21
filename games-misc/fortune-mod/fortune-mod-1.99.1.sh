#!/bin/sh
source "../../common/init.sh"

get http://www.redellipse.net/code/downloads/${P}.tar.xz
acheck

importpkg app-text/recode

cd "${S}"

domake() {
	make \
		prefix="$1/pkg/main/${PKG}.core.${PVR}" \
		FORTDIR="$1/pkg/main/${PKG}.core.${PVR}/bin" \
		COOKIEDIR="$1/pkg/main/${PKG}.data.${PVR}" \
		LOCALDIR="$1/usr/share/games/fortunes" \
		BINDIR="$1/pkg/main/${PKG}.core.${PVR}/bin" \
		BINMANDIR="$1/pkg/main/${PKG}.doc.${PVR}/man/man1" \
		FORTMANDIR="$1/pkg/main/${PKG}.doc.${PVR}/man/man6" \
		LDFLAGS="$LDFLAGS" \
		$2
}

domake
domake "$D" install

finalize
