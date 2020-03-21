#!/bin/sh
source "../../common/init.sh"

get https://www.cpan.org/src/5.0/${P}.tar.gz
acheck

cd "${P}"

importpkg sys-libs/glibc app-arch/bzip2 zlib

# flags for linking system zlib
export BUILD_ZLIB=False
export ZLIB_LIB="/pkg/main/sys-libs.zlib.libs/lib$LIB_SUFFIX"
export ZLIB_INCLUDE="/pkg/main/sys-libs.zlib.dev/include"

# flags for linking system bzip2
export BUILD_BZIP2=0
export BZIP2_LIB="/pkg/main/app-arch.bzip2.libs/lib$LIB_SUFFIX"
export BZIP2_INCLUDE="/pkg/main/app-arch.bzip2.dev/include"

# see: https://perldoc.perl.org/Config.html

sh "${CHPATH}/${P}/Configure" -des -Dprefix="/pkg/main/${PKG}.core.${PVRF}" -Dsiteprefix="/pkg/main/dev-lang.perl-modules.core.${PVRF}" -Dvendorprefix="/pkg/main/${PKG}.core.${PVRF}" \
	-Dman1dir="/pkg/main/${PKG}.doc.${PVRF}/man/man1" -Dman3dir="/pkg/main/${PKG}.doc.${PVRF}/man/man3" \
	-Dsiteman1dir="/pkg/main/dev-lang.perl-modules.doc.${PVRF}/man/man1" -Dsiteman3dir="/pkg/main/dev-lang.perl-modules.doc.${PVRF}/man/man3" \
	-Dman1ext='1' -Dman3ext='3pm' \
	-Dpager="/bin/less -isR" -Duseshrplib -Dusethreads -Uusenm -Duselargefiles -Dd_semctl_semun \
	-Doptimize="${CPPFLAGS} ${CFLAGS} -O2" -Dldflags="${LDFLAGS}" \
	-Dcf_by='AZUSA' -Dmyhostname='localhost' -Dmydomain=".localdomain" -Dperladmin='root@localhost' -Ud_csh-Dsh=/bin/sh -Dtargetsh=/bin/sh

make
make install DESTDIR="${D}"

# make perl modules be in the right path
mv "${D}/pkg/main/dev-lang.perl-modules.core.${PVRF}" "${D}/pkg/main/${PKG}.mod.${PVRF}"

finalize
