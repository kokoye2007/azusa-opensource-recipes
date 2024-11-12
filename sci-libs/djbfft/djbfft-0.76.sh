#!/bin/sh
source "../../common/init.sh"

get http://cr.yp.to/djbfft/"${P}".tar.gz
acheck

cd "${S}" || exit

apatch \
	"${FILESDIR}"/"${P}"-gcc3.patch \
	"${FILESDIR}"/"${P}"-shared.patch \
	"${FILESDIR}"/"${P}"-headers.patch

SOVER="${PV:0:1}.${PV:2:1}.${PV:3:1}" # a.bc -> a.b.c
SONAME="libdjbfft.so.${SOVER}"

sed -i -e "s:\"lib\":\"lib$LIB_SUFFIX\":" hier.c
echo "gcc ${CFLAGS} -fPIC" > "conf-cc"
echo "gcc ${LDFLAGS}" > "conf-ld"
echo "${D}/pkg/main/${PKG}.core.${PVRF}" > "conf-home"
mkdir -pv "${D}/pkg/main/${PKG}.core.${PVRF}"

make LIBDJBFFT="${SONAME}" LIBPERMS=0755 "${SONAME}"
make LIBDJBFFT="${SONAME}" install
./install

ln -snfTv "$SONAME" "${D}/pkg/main/${PKG}.core.${PVRF}/lib$LIB_SUFFIX/libdjbfft.so"
ln -snfTv "$SONAME" "${D}/pkg/main/${PKG}.core.${PVRF}/lib$LIB_SUFFIX/libdjbfft.so.${SOVER%%.*}"

finalize
