#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/mpc/"${P}".tar.gz
acheck

cd "${T}" || exit

# configure & build
doconf --disable-static --with-mpfr-include=/pkg/main/dev-libs.mpfr.dev/include --with-mpfr-lib=$(realpath /pkg/main/dev-libs.mpfr.libs/lib"$LIB_SUFFIX") \
--with-gmp-include=$(realpath /pkg/main/dev-libs.gmp.dev/include) --with-gmp-lib=$(realpath /pkg/main/dev-libs.gmp.libs/lib"$LIB_SUFFIX")

make
make install DESTDIR="${D}"

finalize
