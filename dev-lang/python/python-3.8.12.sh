#!/bin/sh
source "../../common/init.sh"

get https://www.python.org/ftp/python/${PV}/Python-${PV}.tar.xz
acheck

cd "Python-${PV}"

# ensure python can build its "bits" for the following packages
importpkg libffi expat ncurses openssl zlib sqlite3 sys-libs/readline liblzma app-arch/bzip2 sys-libs/gdbm

MODDIR="/pkg/main/dev-lang.python-modules.core.${PV}.${OS}.${ARCH}"

callconf --prefix="$MODDIR" --exec-prefix="/pkg/main/${PKG}.core.${PVRF}" --sysconfdir=/etc --localstatedir=/var --includedir="\${exec_prefix}/include" --datarootdir="\${exec_prefix}/share" \
	--infodir="/pkg/main/${PKG}.doc.${PVRF}/info" --mandir="/pkg/main/${PKG}.doc.${PVRF}/man" --docdir="/pkg/main/${PKG}.doc.${PVRF}" \
	--enable-shared --with-system-expat --with-system-ffi --enable-optimizations --with-computed-gotos --with-dbmliborder=gdbm:bdb --with-libc= --enable-loadable-sqlite-extensions --without-ensurepip

make
make install DESTDIR="${D}"

cd "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
if [ ! -f python ]; then
	# create symlink
	if [ -L python3 ]; then
		cp -aTv python3 python
	fi
fi

# move modules installed to exec-prefix back to prefix
mv "${D}${MODDIR}" "${D}/pkg/main/${PKG}.mod.${PVRF}"

# create symlink to fix confused easy install packages
ln -snf "${MODDIR}/lib/python${PV%.*}/site-packages" "${D}/pkg/main/${PKG}.core.${PVRF}/lib/python${PV%.*}/site-packages"

org_movelib
org_fixdev
fixelf

archive
