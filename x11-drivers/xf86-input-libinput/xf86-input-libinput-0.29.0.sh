#!/bin/sh
source "../../common/init.sh"

get https://www.x.org/pub/individual/driver/"${P}".tar.bz2
acheck

importpkg libudev

cd "${T}" || exit

doconf --localstatedir=/var

make
make install DESTDIR="${D}"

# this will install header files in
# /build/x11-drivers.xf86-input-libinput/0.29.0.linux.amd64/dist/pkg/main/x11-base.xorg-server.dev.1.20.5/include/xorg
if [ -d "${D}/pkg/main/x11-base.xorg-server.dev"* ]; then
	mkdir -p "${D}/pkg/main/${PKG}.dev.${PVRF}"
	mv -v "${D}/pkg/main/x11-base.xorg-server.dev"*/* "${D}/pkg/main/${PKG}.dev.${PVRF}"/

	sed -e "s,^sdkdir=.*,/pkg/main/${PKG}.dev.${PVRF}/include/xorg," -i "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX/pkgconfig/"*.pc
fi

finalize
