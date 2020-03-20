#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/${PN}/${P}.tgz
acheck

importpkg X media-libs/mesa

cd "${S}"

apatch "${FILESDIR}"/${PN}-2.0.0-install-headers.patch \
	"${FILESDIR}"/${P}-mesa-compat.patch

sed -i \
	-e '/INSTALL/s:-s::' \
	-e '/$(CC) $(CFLAGS) -o/s:$(CFLAGS):$(CFLAGS) $(LDFLAGS):' \
	-e '/^.PHONY: .*\.pc$/d' \
	Makefile

# disable static-libs
sed -i \
	-e '/glew.lib:/s|lib/$(LIB.STATIC) ||' \
	-e '/glew.lib.mx:/s|lib/$(LIB.STATIC.MX) ||' \
	-e '/INSTALL.*LIB.STATIC/d' \
	Makefile

# don't do stupid Solaris specific stuff that won't work in Prefix
cp config/Makefile.linux config/Makefile.solaris
# and let freebsd be built as on linux too
cp config/Makefile.linux config/Makefile.freebsd

MAKEOPTS=(
	SYSTEM=linux
	M_ARCH=""
	LDFLAGS.EXTRA="${LDFLAGS}"
	POPT="${CPPFLAGS} -O2"
)

make "${MAKEOPTS[@]}" GLEW_PREFIX="/pkg/main/${PKG}.core.${PVR}" GLEW_DEST="/pkg/main/${PKG}.core.${PVR}" LIBDIR="/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX"
make "${MAKEOPTS[@]}" install.all GLEW_DEST="${D}/pkg/main/${PKG}.core.${PVR}" LIBDIR="${D}/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX" PKGDIR="${D}/pkg/main/${PKG}.dev.${PVR}/pkgconfig"

finalize
