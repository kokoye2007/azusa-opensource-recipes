#!/bin/sh
source "../../common/init.sh"

get https://github.com/linux-pam/linux-pam/releases/download/v${PV}/Linux-PAM-${PV}.tar.xz

echo "Compiling Linux-PAM-${PV} ..."
cd "${T}"

# configure & build
${CHPATH}/Linux-PAM-${PV}/configure >configure.log 2>&1 --prefix=/usr --sysconfdir=/etc --exec-prefix=/pkg/main/${PKG}.core.${PVR} \
--includedir=/pkg/main/${PKG}.dev.${PVR}/include --libdir=/pkg/main/${PKG}.libs.${PVR} --datarootdir=/pkg/main/${PKG}.core.${PVR}/share \
--mandir=/pkg/main/${PKG}.doc.${PVR}/man --docdir=/pkg/main/${PKG}.doc.${PVR}/doc

make >make.log 2>&1
make >make_install.log 2>&1 install DESTDIR="${D}"

cd "${D}"

mv etc pkg/main/${PKG}.core.${PVR}
mv sbin pkg/main/${PKG}.core.${PVR}

finalize
