#!/bin/sh
source "../../common/init.sh"

get http://deb.debian.org/debian/pool/main/libg/libgsm/libgsm_${PV}.orig.tar.gz

cd */

patch -p1 <"$FILESDIR/gsm-${PV}-shared.patch"

make

mkdir -pv "${D}/pkg/main/${PKG}.core.${PVR}"/bin "${D}/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX" "${D}/pkg/main/${PKG}.dev.${PVR}/include" "${D}/pkg/main/${PKG}.doc.${PVR}/man"/man{1,3}
make install \
	INSTALL_ROOT="${D}/pkg/main/${PKG}.core.${PVR}" \
	GSM_INSTALL_LIB="${D}/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX" \
	GSM_INSTALL_INC="${D}/pkg/main/${PKG}.dev.${PVR}/include" \
	GSM_INSTALL_MAN="${D}/pkg/main/${PKG}.doc.${PVR}/man/man3" \
	TOAST_INSTALL_MAN="${D}/pkg/main/${PKG}.doc.${PVR}/man/man1"

# copy shared lib & remove static lib
mv -v lib/libgsm.so* "${D}/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX"
rm -fv "${D}/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX"/*.a

finalize
