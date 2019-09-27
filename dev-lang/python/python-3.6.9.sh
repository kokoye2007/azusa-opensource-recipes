#!/bin/sh
source "../../common/init.sh"

get https://www.python.org/ftp/python/${PV}/Python-${PV}.tar.xz
acheck

cd "Python-${PV}"

# ensure python can build its "bits" for the following packages
importpkg libffi expat ncurses openssl zlib sqlite3 readline liblzma app-arch/bzip2 sys-libs/gdbm

callconf --prefix="/pkg/main/dev-lang.python-modules.core.${PV}" --exec-prefix="/pkg/main/${PKG}.core.${PVR}" --sysconfdir=/etc --localstatedir=/var --includedir="\${exec_prefix}/include" --datarootdir="\${exec_prefix}/share" \
	--infodir="/pkg/main/${PKG}.doc.${PVR}/info" --mandir="/pkg/main/${PKG}.doc.${PVR}/man" --docdir="/pkg/main/${PKG}.doc.${PVR}" \
	--enable-shared --with-system-expat --with-system-ffi --enable-optimizations --with-computed-gotos --with-dbmliborder=gdbm:bdb --with-libc= --enable-loadable-sqlite-extensions --without-ensurepip

make
make install DESTDIR="${D}"

# move modules installed to exec-prefix back to prefix
mv "${D}/pkg/main/dev-lang.python-modules.core.${PV}" "${D}/pkg/main/${PKG}.mod.${PVR}"

# create symlink to fix confused easy install packages
ln -snf "/pkg/main/dev-lang.python-modules.core.${PV}/lib/python${PV%.*}/site-packages" "${D}/pkg/main/${PKG}.core.${PVR}/lib/python${PV%.*}/site-packages"

finalize
