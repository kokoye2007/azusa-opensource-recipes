#!/bin/sh
source "../../common/init.sh"

get http://ftp.jaist.ac.jp/pub/Linux/Gentoo/distfiles/termcap-"${PV}".tar.bz2
cd termcap-"${PV}" || exit
get http://ftp.jaist.ac.jp/pub/Linux/Gentoo/distfiles/termcap-"${PV}"-patches-2.tar.bz2
apatch patch/*.patch
get http://www.catb.org/~esr/terminfo/termtypes.tc.gz
mv termtypes.tc termcap
apatch patch/tc.file/*.patch

apatch "$FILESDIR"/"${P}"-relative-lib-symlink.patch
acheck

make CFLAGS="-O2 -I."

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/lib$LIB_SUFFIX"
if [ x"$LIB_SUFFIX" != x ]; then
	ln -snfv "lib$LIB_SUFFIX" "${D}/pkg/main/${PKG}.core.${PVRF}/lib"
fi
make install prefix="${D}/pkg/main/${PKG}.core.${PVRF}"

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/etc"
cp -v termcap "${D}/pkg/main/${PKG}.core.${PVRF}/etc"

finalize
