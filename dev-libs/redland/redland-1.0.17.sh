#!/bin/sh
source "../../common/init.sh"

get http://download.librdf.org/source/"${P}".tar.gz
acheck

cd "${T}" || exit

importpkg mariadb dev-libs/rasqal

doconf --with-virtuoso --with-unixodbc --without-iodbc --disable-static --with-bdb --with-mysql --with-sqlite --with-postgresql --without-threads --with-html-dir="/pkg/main/${PKG}.doc.${PVRF}/html"

make
make install DESTDIR="${D}"

finalize
