#!/bin/sh
source "../../common/init.sh"

get http://www.digitalforensicssolutions.com/Scalpel/${P}.tar.gz
acheck

cd "${P}"
# Set the default config file location
sed -i -e "s:scalpel.conf:/etc/\0:" src/scalpel.h

cd "${T}"

importpkg dev-libs/tre

doconf

make
make install DESTDIR="${D}"

finalize
