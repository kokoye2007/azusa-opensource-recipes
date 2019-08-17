#!/bin/sh
source "../../common/init.sh"

get http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/${P}/${P}.tar.xz

cd "${T}"

# configure & build
doconf --enable-languages=c,c++ --disable-bootstrap --disable-libmpx --with-system-zlib \
--with-mpfr-include=`realpath /pkg/main/dev-libs.mpfr.dev/include` --with-mpfr-lib=`realpath /pkg/main/dev-libs.mpfr.libs/lib` \
--with-mpc-include=`realpath /pkg/main/dev-libs.mpc.dev/include` --with-mpc-lib=`realpath /pkg/main/dev-libs.mpc.libs/lib` \
--with-gmp-include=`realpath /pkg/main/dev-libs.gmp.dev/include` --with-gmp-lib=`realpath /pkg/main/dev-libs.gmp.libs/lib` \
--with-isl-include=`realpath /pkg/main/dev-libs.isl.dev/include` --with-isl-lib=`realpath /pkg/main/dev-libs.isl.libs/lib`


# prepare things a bit
mkdir -p pkg/main/${PKG}.libs.${PVR}/lib64
ln -s lib64 pkg/main/${PKG}.libs.${PVR}/lib

make
make install DESTDIR="${D}"

cd "${D}"

finalize
