#!/bin/sh
source "../../common/init.sh"

get http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/${P}/${P}.tar.xz
cd "${P}"
get http://distfiles.gentoo.org/distfiles/gcc-${PV}-patches-3.tar.bz2
apatch patch/*.patch
acheck

cd "${T}"

export SED=sed

# make sure gcc can find stuff like -lz
importpkg zlib

export CPP=/pkg/main/sys-devel.gcc.core/bin/cpp

# configure & build
callconf --prefix=/pkg/main/${PKG}.core.${PVRF} --infodir=/pkg/main/${PKG}.doc.${PVRF}/info --mandir=/pkg/main/${PKG}.doc.${PVRF}/man --docdir=/pkg/main/${PKG}.doc.${PVRF}/gcc \
--libdir=/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX --with-slibdir=/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX \
--with-gxx-include-dir=/pkg/main/${PKG}.dev.${PVRF}/include/c++ --with-sysroot=/pkg/main/sys-libs.glibc.dev \
--with-gcc-major-version-only \
--enable-languages=c,c++ --disable-multilib --disable-bootstrap --disable-libmpx --with-system-zlib \
--with-mpfr-include=`realpath /pkg/main/dev-libs.mpfr.dev/include` --with-mpfr-lib=`realpath /pkg/main/dev-libs.mpfr.libs/lib$LIB_SUFFIX` \
--with-mpc-include=`realpath /pkg/main/dev-libs.mpc.dev/include` --with-mpc-lib=`realpath /pkg/main/dev-libs.mpc.libs/lib$LIB_SUFFIX` \
--with-gmp-include=`realpath /pkg/main/dev-libs.gmp.dev/include` --with-gmp-lib=`realpath /pkg/main/dev-libs.gmp.libs/lib$LIB_SUFFIX` \
--with-isl-include=`realpath /pkg/main/dev-libs.isl.dev/include` --with-isl-lib=`realpath /pkg/main/dev-libs.isl.libs/lib$LIB_SUFFIX`

make
make install DESTDIR="${D}"

ln -sv gcc "${D}/pkg/main/${PKG}.core.${PVRF}/bin/cc"

# remove any .la file
find "${D}" -name '*.la' -delete

# do not use finalize because we depend on location of some files
archive
