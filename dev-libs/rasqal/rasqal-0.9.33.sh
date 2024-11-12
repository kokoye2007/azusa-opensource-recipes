#!/bin/sh
source "../../common/init.sh"

get http://download.librdf.org/source/"${P}".tar.gz
acheck

cd "${T}" || exit

importpkg libxml-2.0

doconf --with-decimal=gmp --with-uuid-library=libuuid --enable-pcre --with-regex-library=pcre --disable-static --enable-xml2 --with-digest-library=gcrypt

make
make install DESTDIR="${D}"

finalize
