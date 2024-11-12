#!/bin/sh
source "../../common/init.sh"

MY_PV="${PV//./}"
MY_PV="${MY_PV%_p*}"
get "https://downloads.sourceforge.net/infozip/unzip${MY_PV}.tar.gz"
get "http://ftp.us.debian.org/debian/pool/main/u/${PN}/${PN}_${PV/_p/-}.debian.tar.xz"
acheck

cd "${S}" || exit

deb="${WORKDIR}"/debian/patches
rm "${deb}"/02-this-is-debian-unzip.patch
apatch "${deb}"/*.patch

CPPFLAGS="${CPPFLAGS} -DNO_LCHMOD -DUSE_BZIP2 -DUNICODE_SUPPORT -DUNICODE_WCHAR -DUTF8_MAYBE_NATIVE -DUSE_ICONV_MAPPING -DLARGE_FILE_SUPPORT"

make -f unix/Makefile generic
make prefix="${D}/pkg/main/${PKG}.core.${PVRF}" MANDIR="${D}/pkg/main/${PKG}.doc.${PVRF}/man" \
 -f unix/Makefile install

finalize
