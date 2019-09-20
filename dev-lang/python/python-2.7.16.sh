#!/bin/sh
source "../../common/init.sh"

get https://www.python.org/ftp/python/${PV}/Python-${PV}.tar.xz

cd "Python-${PV}"

# ensure python can build its "bits" for the following packages
CFLAGS="-I/pkg/main/app-arch.bzip2.dev/include"
LDFLAGS="-L/pkg/main/app-arch.bzip2.libs/lib64"
importpkg libffi expat ncurses openssl zlib sqlite3 readline

callconf --prefix="/pkg/main/dev-lang.python-modules.${PV}" --exec-prefix="/pkg/main/${PKG}.core.${PVR}" --sysconfdir=/etc --localstatedir=/var --includedir="\${exec_prefix}/include" --datarootdir="\${exec_prefix}/share" \
	--infodir="/pkg/main/${PKG}.doc.${PVR}/info" --mandir="/pkg/main/${PKG}.doc.${PVR}/man" --docdir="/pkg/main/${PKG}.doc.${PVR}" \
	--enable-shared --with-system-expat --with-system-ffi --with-ensurepip=install --enable-unicode=ucs4 --enable-optimizations

make
make install DESTDIR="${D}"

# move modules installed to exec-prefix back to prefix
mv "${D}/pkg/main/dev-lang.python-modules.${PV}" "${D}/pkg/main/${PKG}.mod.${PVR}"

finalize
