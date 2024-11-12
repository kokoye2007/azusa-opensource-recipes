#!/bin/sh
source "../../common/init.sh"
envcheck
# do not use acheck so we keep networking

export PATH="/pkg/main/dev-lang.go.dev.1.19/bin:$PATH"

echo -n "Using: "
go version

export GOBIN="${D}/pkg/main/${PKG}.core.${PVRF}/bin"
mkdir -pv "$GOBIN"
go install -v github.com/0xPolygon/polygon-edge@v"${PV}"
if [ ! -f "$GOBIN/polygon-edge" ]; then
	echo "Build failed"
	exit
fi

finalize
