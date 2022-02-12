#!/bin/sh
source "../../common/init.sh"

get https://www.cpan.org/src/5.0/${P}.tar.gz
acheck

cd "${P}"

importpkg sys-libs/glibc app-arch/bzip2 zlib sys-libs/gdbm

# flags for linking system zlib
export BUILD_ZLIB=False
export ZLIB_LIB="/pkg/main/sys-libs.zlib.libs/lib$LIB_SUFFIX"
export ZLIB_INCLUDE="/pkg/main/sys-libs.zlib.dev/include"

# flags for linking system bzip2
export BUILD_BZIP2=0
export BZIP2_LIB="/pkg/main/app-arch.bzip2.libs/lib$LIB_SUFFIX"
export BZIP2_INCLUDE="/pkg/main/app-arch.bzip2.dev/include"

case $ARCH in
	amd64) archname="x86_64-linux" ;;
	arm64) archname="aarch64-linux" ;;
	*) die "unsupported arch $ARCH - please add" ;;
esac

# see: https://perldoc.perl.org/Config.html
CONFOPTS=(
	-des
	-Darchname="$archname"
	-Dprefix="/pkg/main/${PKG}.core.${PVRF}"
	-Dsiteprefix="/pkg/main/dev-lang.perl-modules.core.${PVRF}"
	-Dvendorprefix="/pkg/main/dev-lang.perl-modules.core.${PVRF}"
	-Dprivlib="/pkg/main/dev-lang.perl-modules.core.${PVRF}/lib/priv"
	-Dscriptdir="/pkg/main/dev-lang.perl-modules.core.${PVRF}/bin"
	-Darchlib="/pkg/main/dev-lang.perl-modules.core.${PVRF}/lib/${archname}"
	-Dsitelib="/pkg/main/dev-lang.perl-modules.core.${PVRF}/lib/site"
	-Dsitearch="/pkg/main/dev-lang.perl-modules.core.${PVRF}/lib/site/${archname}"
	-Dvendorlib="/pkg/main/dev-lang.perl-modules.core.${PVRF}/lib/vendor"
	-Dvendorarch="/pkg/main/dev-lang.perl-modules.core.${PVRF}/lib/vendor/${archname}"
	-Dinstallusrbinperl=n
	-Dlibperl="libperl.so.${PV}"

	-Dman1dir="/pkg/main/${PKG}.doc.${PVRF}/man/man1"
	-Dman3dir="/pkg/main/${PKG}.doc.${PVRF}/man/man3"
	-Dsiteman1dir="/pkg/main/dev-lang.perl-modules.doc.${PVRF}/man/man1"
	-Dsiteman3dir="/pkg/main/dev-lang.perl-modules.doc.${PVRF}/man/man3"
	-Dvendorman1dir="/pkg/main/dev-lang.perl-modules.doc.${PVRF}/man/man1"
	-Dvendorman3dir="/pkg/main/dev-lang.perl-modules.doc.${PVRF}/man/man3"
	-Dman1ext='1'
	-Dman3ext='3pm'

	-Dpager="/bin/less -isR"
	-Duseshrplib
	-Dusethreads
	-Uusenm
	-Duselargefiles
	-Dd_semctl_semun
	-Doptimize="${CPPFLAGS} ${CFLAGS} -O2 -pipe"
	-Dldflags="${LDFLAGS} -Wl,-O1 -Wl,--as-needed"
	-Dcf_by='AZUSA'
	-Dmyhostname='localhost'
	-Dperladmin='root@localhost'
	-Ud_csh
	-Dsh=/bin/sh
	-Dtargetsh=/bin/sh
	-Ui_xlocale
	-Ui_ndbm
	-Di_gdbm
	-Ui_db
	-DDEBUGGING=none
)

sh "${CHPATH}/${P}/Configure" "${CONFOPTS[@]}"

make
make install DESTDIR="${D}"

mkdir -p "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
cp -v "libperl.so.${PV}" "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
# symlinks for the lib (kinda)
ln -snfv "libperl.so.${PV}" "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX/libperl.so.${PV%.*}"
ln -snfv "libperl.so.${PV}" "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX/libperl.so"

# make perl modules be in the right path
mv "${D}/pkg/main/dev-lang.perl-modules.core.${PVRF}" "${D}/pkg/main/${PKG}.mod.${PVRF}"

fixelf
archive
