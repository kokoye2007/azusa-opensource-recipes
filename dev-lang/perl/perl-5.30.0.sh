#!/bin/sh
source "../../common/init.sh"

get https://www.cpan.org/src/5.0/${P}.tar.gz
acheck

cd "${P}"

importpkg sys-libs/glibc app-arch/bzip2 zlib
export LIBS="-lpthread -lm"

export BUILD_ZLIB=False
export BUILD_BZIP2=0

sh "${CHPATH}/${P}/Configure" -des -Dprefix="/pkg/main/${PKG}.core.${PVR}" -Dsiteprefix="/pkg/main/dev-lang.perl-modules.core.${PVR}" -Dvendorprefix="/pkg/main/${PKG}.core.${PVR}" -Dman1dir="/pkg/main/${PKG}.doc.${PVR}/man/man1" -Dman3dir="/pkg/main/${PKG}.doc.${PVR}/man/man3" -Dpager="/usr/bin/less -isR" -Duseshrplib -Dusethreads -Uusenm -Doptimize="${CPPFLAGS} ${CFLAGS}" -Dldflags="${LDFLAGS}" -Duselargefiles -Dd_semctl_semun -Dcf_by='AZUSA' -Dmyhostname='localhost' -Dperladmin='root@localhost' -Ud_csh-Dsh=/bin/sh -Dtargetsh=/bin/sh

make
make install DESTDIR="${D}"

# make perl modules be in the right path
mv "${D}/pkg/main/dev-lang.perl-modules.core.${PVR}" "${D}/pkg/main/${PKG}.mod.${PVR}"

finalize
