#!/bin/sh
source "../../common/init.sh"

get http://www.digitalforensicssolutions.com/Scalpel/"${P}".tar.gz
acheck

cd "${P}" || exit
# Set the default config file location
sed -i -e "s:scalpel.conf:/etc/\0:" src/scalpel.h

cd "${T}" || exit

importpkg dev-libs/tre

doconf

make
make install DESTDIR="${D}"

finalize
