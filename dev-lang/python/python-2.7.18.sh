#!/bin/sh
source "../../common/init.sh"

get https://www.python.org/ftp/python/${PV}/Python-${PV}.tar.xz
acheck

cd "Python-${PV}"

# ensure python can build its "bits" for the following packages
importpkg libffi expat ncurses openssl zlib sqlite3 readline app-arch/bzip2 sys-libs/gdbm

echo "DEBUG"
echo $CFLAGS
echo $LDFLAGS

callconf --prefix="/pkg/main/dev-lang.python-modules.core.${PV}" --exec-prefix="/pkg/main/${PKG}.core.${PVRF}" --sysconfdir=/etc --localstatedir=/var --includedir="\${exec_prefix}/include" --datarootdir="\${exec_prefix}/share" \
	--infodir="/pkg/main/${PKG}.doc.${PVRF}/info" --mandir="/pkg/main/${PKG}.doc.${PVRF}/man" --docdir="/pkg/main/${PKG}.doc.${PVRF}" \
	--enable-shared --with-system-expat --with-system-ffi --enable-unicode=ucs4 --enable-optimizations --with-threads --with-fpectl --with-computed-gotos --with-dbmliborder=gdbm:bdb --with-libc= --without-ensurepip

make
make install DESTDIR="${D}"

# move modules installed to exec-prefix back to prefix
mv "${D}/pkg/main/dev-lang.python-modules.core.${PV}" "${D}/pkg/main/${PKG}.mod.${PVRF}"

# create symlink to fix confused easy install packages
ln -snf "/pkg/main/dev-lang.python-modules.core.${PV}/lib/python${PV%.*}/site-packages" "${D}/pkg/main/${PKG}.core.${PVRF}/lib/python${PV%.*}/site-packages"

archive
