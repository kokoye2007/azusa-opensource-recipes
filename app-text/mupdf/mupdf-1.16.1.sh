#!/bin/sh
source "../../common/init.sh"

get https://mupdf.com/downloads/archive/${P}-source.tar.xz
acheck

cd "${S}"

PKGCONFIG="libopenjp2 glu gl glut harfbuzz"
XCFLAGS="$(pkg-config --cflags ${PKGCONFIG}) -O2"
XLIBS="$(pkg-config --libs ${PKGCONFIG})"

echo "pkg-config: $PKGCONFIG"
echo "XCFLAGS: $XCFLAGS"
echo "XLIBS: $XLIBS"

apatch $FILESDIR/${P}-*.patch

MAKEOPTS=(
	XCFLAGS="$XCFLAGS"
	XLIBS="$XLIBS"
	USE_SYSTEM_LIBS=yes
	verbose=yes
	DESTDIR="${D}"
	prefix="/pkg/main/${PKG}.core.${PVRF}"
	build=release
	docdir="/pkg/main/${PKG}.doc.${PVRF}"
)

make "${MAKEOPTS[@]}"
make install "${MAKEOPTS[@]}"

ln -sfv mupdf-x11 "${D}/pkg/main/${PKG}.core.${PVRF}/bin/mupdf"

finalize
