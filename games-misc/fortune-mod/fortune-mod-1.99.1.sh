#!/bin/sh
source "../../common/init.sh"

get http://www.redellipse.net/code/downloads/${P}.tar.xz
acheck

importpkg app-text/recode

cd "${S}"

domake() {
	make \
		prefix="$1/pkg/main/${PKG}.core.${PVRF}" \
		FORTDIR="$1/pkg/main/${PKG}.core.${PVRF}/bin" \
		COOKIEDIR="$1/pkg/main/${PKG}.data.${PVRF}" \
		LOCALDIR="$1/usr/share/games/fortunes" \
		BINDIR="$1/pkg/main/${PKG}.core.${PVRF}/bin" \
		BINMANDIR="$1/pkg/main/${PKG}.doc.${PVRF}/man/man1" \
		FORTMANDIR="$1/pkg/main/${PKG}.doc.${PVRF}/man/man6" \
		LDFLAGS="$LDFLAGS" \
		$2
}

domake
domake "$D" install

finalize
