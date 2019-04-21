#!/bin/sh
source "../../common/init.sh"

get https://www.cpan.org/src/5.0/${P}.tar.gz

cd "${P}"

export BUILD_ZLIB=False
export BUILD_BZIP2=0

sh "${CHPATH}/${P}/Configure" -des -Dprefix="/pkg/main/${PKG}.core.${PVR}" -Dvendorprefix="/pkg/main/${PKG}.core.${PVR}" -Dman1dir="/pkg/main/${PKG}.doc.${PVR}/man/man1" -Dman3dir="/pkg/main/${PKG}.doc.${PVR}/man/man3" -Dpager="/usr/bin/less -isR" -Duseshrplib -Dusethreads

make
make install DESTDIR="${D}"

finalize