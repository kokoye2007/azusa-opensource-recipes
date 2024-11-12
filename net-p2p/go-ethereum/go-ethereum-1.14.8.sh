#!/bin/sh
source "../../common/init.sh"
get https://github.com/ethereum/go-ethereum/archive/refs/tags/v"${PV}".tar.gz "${P}".tar.gz
envcheck
# do not use acheck so we keep networking

export PATH="/pkg/main/dev-lang.go.dev.1.21/bin:$PATH"

cd "${S}" || exit

echo -n "Using: "
go version

make all

mkdir -pv "${D}/pkg/main/${PKG}.core.${PVRF}"
mv -v build/bin "${D}/pkg/main/${PKG}.core.${PVRF}"

finalize
