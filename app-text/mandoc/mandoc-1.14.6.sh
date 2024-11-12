#!/bin/sh
source "../../common/init.sh"

get https://mdocml.bsd.lv/snapshots/"${P}".tar.gz
acheck

cd "${S}" || exit

importpkg zlib

cat <<-EOF > "configure.local"
	PREFIX="/pkg/main/${PKG}.core.${PVRF}"
	BINDIR="/pkg/main/${PKG}.core.${PVRF}/bin"
	SBINDIR="/pkg/main/${PKG}.core.${PVRF}/sbin"
	LIBDIR="/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
	MANDIR="/pkg/main/${PKG}.doc.${PVRF}/man"
	INCLUDEDIR="/pkg/main/${PKG}.dev.${PVRF}/include/mandoc"
	EXAMPLEDIR="/pkg/main/${PKG}.dev.${PVRF}/examples/mandoc"
	MANPATH_DEFAULT="/pkg/main/azusa.symlinks.core/man:${EPREFIX}/usr/local/man:${EPREFIX}/usr/local/share/man"

	CFLAGS="${CFLAGS} ${CPPFLAGS}"
	LDFLAGS="${LDFLAGS}"
	AR="ar"
	CC="gcc"
	# The STATIC variable is only used by man.cgi.
	STATIC=

	# conflicts with sys-apps/groff
	BINM_SOELIM=msoelim
	MANM_ROFF=mandoc_roff
	# conflicts with sys-apps/man-pages
	MANM_MAN=mandoc_man
EOF

callconf

make
make install DESTDIR="${D}"

finalize
