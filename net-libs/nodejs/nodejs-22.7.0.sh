#!/bin/sh
source "../../common/init.sh"

get https://nodejs.org/dist/v${PV}/node-v${PV}.tar.xz
acheck

cd "node-v${PV}"

# fix include
sed -i 's|ares_nameser.h|arpa/nameser.h|' src/cares_wrap.h
# increase limit so ld works
ulimit -n 65536

doconflight --shared-cares --shared-libuv --shared-nghttp2 --shared-nghttp2-libpath=$(pkg-config --variable libdir libnghttp2) --shared-openssl --with-snapshot --shared-zlib --with-intl=system-icu

make -j"$NPROC"
make install DESTDIR="${D}"

# move "node_modules" to its own "mod" package
mkdir -p "${D}/pkg/main/${PKG}.mod.${PVRF}"
mv "${D}/pkg/main/${PKG}.core.${PVRF}/lib/node_modules" "${D}/pkg/main/${PKG}.mod.${PVRF}"
ln -snf "/pkg/main/${PKG}.mod.${PVRF}/node_modules" "${D}/pkg/main/${PKG}.core.${PVRF}/lib/node_modules"

finalize
