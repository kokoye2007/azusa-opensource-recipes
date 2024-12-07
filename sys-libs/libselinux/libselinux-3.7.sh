#!/bin/sh
source "../../common/init.sh"

get https://github.com/SELinuxProject/selinux/releases/download/${PV}/${P}.tar.gz
acheck

importpkg sys-libs/libsepol dev-libs/libpcre2

CPPFLAGS="${CPPFLAGS} -DPIE -fPIE -fno-semantic-interposition -Wno-stringop-truncation"
LDFLAGS="${LDFLAGS} -pthread"

cd "${S}"

MAKEOPTS=(
	USE_PCRE2=y
	CC="gcc ${CPPFLAGS}"
	LDFLAGS="${LDFLAGS}"
	PREFIX="/pkg/main/${PKG}.core.${PVRF}"
	LIBDIR="/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
	DESTDIR="${D}"
)

make "${MAKEOPTS[@]}"
make install "${MAKEOPTS[@]}"

# fix pkgconfig file
# ${D}/pkg/main/${PKG}.libs.${PVRF}/lib${LIB_SUFFIX}/pkgconfig

echo "Fixing libselinux.pc"
sed -i -re 's/^Libs:(.*)/Libs:\1 -lpcre2-8/' "${D}/pkg/main/${PKG}.libs.${PVRF}/lib${LIB_SUFFIX}/pkgconfig/libselinux.pc"

finalize
