#!/bin/sh
source "../../common/init.sh"

# in order to know latest version:
# https://versionhistory.googleapis.com/v1/chrome/platforms/linux/channels/stable/versions

# https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_76.0.3809.132-1_amd64.deb
get https://dl.google.com/linux/chrome/deb/pool/main/g/${PN}-stable/${PN}-stable_${PV}_amd64.deb
acheck

ar x "${PN}-stable_${PV}_amd64.deb"
tar xvf data.tar.xz

rm -r etc

# todo ... a lot of stuff...

# move language packs to separate packages (+symlinks)

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}"
mv usr/* "${D}/pkg/main/${PKG}.core.${PVRF}"
mv opt/google/chrome "${D}/pkg/main/${PKG}.core.${PVRF}"

# set suid bit on chrome-sandbox, and limit to +x
chmod -v 04711 "${D}/pkg/main/${PKG}.core.${PVRF}/chrome/chrome-sandbox"

cd "${D}/pkg/main/${PKG}.core.${PVRF}"
rm bin/google-chrome-stable

ln -s /pkg/main/${PKG}.core.${PVRF}/chrome/google-chrome bin/google-chrome-stable

# ...

finalize
