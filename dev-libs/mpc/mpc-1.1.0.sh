#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/mpc/${P}.tar.gz

cd "${T}"

# configure & build
doconf --disable-static --with-mpfr-include=/pkg/main/dev-libs.mpfr.dev/include --with-mpfr-lib=`realpath /pkg/main/dev-libs.mpfr.libs/lib$LIB_SUFFIX` \
--with-gmp-include=`realpath /pkg/main/dev-libs.gmp.dev/include` --with-gmp-lib=`realpath /pkg/main/dev-libs.gmp.libs/lib`

make
make install DESTDIR="${D}"

finalize
