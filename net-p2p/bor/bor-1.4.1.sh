#!/bin/sh
source "../../common/init.sh"
fetchgit https://github.com/maticnetwork/bor.git v${PV}

envcheck
# do not use acheck so we keep networking

export PATH="/pkg/main/dev-lang.go.dev/bin:$PATH"
export GOBIN="${D}/pkg/main/${PKG}.core.${PVRF}/bin"
mkdir -pv "$GOBIN"

cd "${S}"
make bor
mkdir -p $GOBIN
mv -v build/bin/bor $GOBIN
mkdir -p "${D}/pkg/main/${PKG}.data.${PVRF}/templates"
mv -v packaging/templates/mainnet-* packaging/templates/testnet-* "${D}/pkg/main/${PKG}.data.${PVRF}/templates"

cp README.md "${D}/pkg/main/${PKG}.core.${PVRF}/"

if [ ! -f "$GOBIN/bor" ]; then
	echo "Build failed"
	exit
fi

finalize
