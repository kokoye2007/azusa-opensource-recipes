#!/bin/sh
source "../../common/init.sh"
fetchgit https://github.com/maticnetwork/heimdall.git v"${PV}"

envcheck
# do not use acheck so we keep networking

export PATH="/pkg/main/dev-lang.go.dev/bin:$PATH"
export GOBIN="${D}/pkg/main/${PKG}.core.${PVRF}/bin"
mkdir -pv "$GOBIN"

cd "${S}" || exit
make install

cp README.md LICENSE "${D}/pkg/main/${PKG}.core.${PVRF}/"

if [ ! -f "$GOBIN/heimdalld" ]; then
	echo "Build failed"
	exit
fi

finalize
