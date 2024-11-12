#!/bin/sh
source "../../common/init.sh"

get http://www.abisource.com/downloads/wv/"${PV}"/"${P}".tar.gz
acheck

cd "${T}" || exit

# libpng is not diectly required but is a dep of libwmf
importpkg dev-libs/icu libpng
export CFLAGS="-O2" # prefent wv from adding -ansi which will choke on icu headers

doconf --disable-static --with-libwmf

make
make install DESTDIR="${D}"

finalize
