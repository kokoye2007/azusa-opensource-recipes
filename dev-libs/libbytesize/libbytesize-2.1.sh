#!/bin/sh
source "../../common/init.sh"

get https://github.com/storaged-project/libbytesize/releases/download/2.1/"${P}".tar.gz
acheck

cd "${T}" || exit

importpkg dev-libs/gmp mpfr libpcre2-8

doconf

make
make install DESTDIR="${D}"

finalize
