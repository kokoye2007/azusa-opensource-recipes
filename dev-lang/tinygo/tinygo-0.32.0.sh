#!/bin/sh
source "../../common/init.sh"

fetchgit https://github.com/tinygo-org/tinygo.git v${PV}
envcheck

export PATH="/pkg/main/dev-lang.go.dev/bin:$PATH"

echo -n "Using: "
go version

cd "${S}"
make llvm-source
make llvm-build
make build/release

mkdir -p "${D}/pkg/main"
mv -v "build/release/tinygo" "${D}/pkg/main/${PKG}.core.${PVRF}/"

fixelf
archive
