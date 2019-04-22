#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/mpc/${P}.tar.gz

cd "${T}"

# configure & build
doconf --disable-static --with-mpfr-include=/pkg/main/dev-libs.mpfr.dev/include --with-mpfr-lib=/pkg/main/dev-libs.mpfr.libs/lib \
--with-gmp-include=/pkg/main/dev-libs.gmp.dev/include --with-gmp-lib=/pkg/main/dev-libs.gmp.libs/lib

make
make install DESTDIR="${D}"

finalize
