#!/bin/sh
source "../../common/init.sh"

get http://deb.debian.org/debian/pool/main/libg/libgsm/libgsm_${PV}.orig.tar.gz
acheck

cd "${S}"

apatch "$FILESDIR/gsm-${PV}-shared.patch"

make

mkdir -pv "${D}/pkg/main/${PKG}.core.${PVRF}"/bin "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX" "${D}/pkg/main/${PKG}.dev.${PVRF}/include" "${D}/pkg/main/${PKG}.doc.${PVRF}/man"/man{1,3}
make install \
	INSTALL_ROOT="${D}/pkg/main/${PKG}.core.${PVRF}" \
	GSM_INSTALL_LIB="${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX" \
	GSM_INSTALL_INC="${D}/pkg/main/${PKG}.dev.${PVRF}/include" \
	GSM_INSTALL_MAN="${D}/pkg/main/${PKG}.doc.${PVRF}/man/man3" \
	TOAST_INSTALL_MAN="${D}/pkg/main/${PKG}.doc.${PVRF}/man/man1"

# copy shared lib & remove static lib
mv -v lib/libgsm.so* "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
rm -fv "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"/*.a

finalize
