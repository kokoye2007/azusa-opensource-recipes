#!/bin/sh
source "../../common/init.sh"

OS=any
ARCH=any

MY_PN="${PN/timidity-/}"
get http://freepats.opensrc.org/${MY_PN}-${PV}.tar.bz2
acheck

cd "${S}"

echo "dir /pkg/main/${PKG}.data.${PVR}.any.any" > timidity.cfg
cat freepats.cfg >> timidity.cfg

mkdir -p "${D}/pkg/main/${PKG}.data.${PVR}.any.any"
cp -r -t "${D}/pkg/main/${PKG}.data.${PVR}.any.any" timidity.cfg Drum_000 Tone_000

mkdir -p "${D}/pkg/main/${PKG}.doc.${PVR}.any.any"
cp README "${D}/pkg/main/${PKG}.doc.${PVR}.any.any"

archive
