#!/bin/sh
source "../../common/init.sh"
inherit utils

CD_VERSION="1.2"
get https://downloads.sourceforge.net/scummvm/BASS-Floppy-${PV}.zip
get https://downloads.sourceforge.net/scummvm/bass-cd-${CD_VERSION}.zip
acheck

mkdir -pv "${D}/pkg/main/${PKG}.data.floppy.${PVR}"
mv -v sky.* readme.txt "${D}/pkg/main/${PKG}.data.floppy.${PVR}"
mv -vT "bass-cd-$CD_VERSION" "${D}/pkg/main/${PKG}.data.cd.${PVR}"

mkdir -pv "${D}/pkg/main/${PKG}.core.${PVR}/libexec"

cp -v "$FILESDIR/scummvmGetLang.sh" "${D}/pkg/main/${PKG}.core.${PVR}/libexec"
chmod -v +x "${D}/pkg/main/${PKG}.core.${PVR}/libexec/scummvmGetLang.sh"

# generate wrappers
make_wrapper bass "scummvm -f -p \"/pkg/main/${PKG}.data.floppy.${PVR}\" -q\$(/pkg/main/${PKG}.core.${PVR}/libexec/scummvmGetLang.sh) sky" .
make_wrapper bass-cd "scummvm -f -p \"/pkg/main/${PKG}.data.cd.${PVR}\" -q\$(/pkg/main/${PKG}.core.${PVR}/libexec/scummvmGetLang.sh) sky" .

archive
