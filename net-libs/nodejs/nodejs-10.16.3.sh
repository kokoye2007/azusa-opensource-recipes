#!/bin/sh
source "../../common/init.sh"

get https://nodejs.org/dist/v${PV}/node-v${PV}.tar.xz

cd "node-v${PV}"

doconflight --shared-cares --shared-libuv --shared-nghttp2 --shared-nghttp2-libpath=$(pkg-config --variable libdir libnghttp2) --shared-openssl --with-snapshot --shared-zlib --with-intl=system-icu

make
make install DESTDIR="${D}"

# move "node_modules" to its own "mod" package
mkdir -p "${D}/pkg/main/${PKG}.mod.${PVR}"
mv "${D}/pkg/main/${PKG}.core.${PVR}/lib/node_modules" "${D}/pkg/main/${PKG}.mod.${PVR}"
ln -snf "/pkg/main/${PKG}.mod.${PVR}/node_modules" "${D}/pkg/main/${PKG}.core.${PVR}/lib/node_modules"

finalize
