#!/bin/sh
source "../../common/init.sh"
envcheck
# do not use acheck so we keep networking

export PATH="/pkg/main/dev-lang.go.dev/bin:$PATH"

echo -n "Using: "
go version

export GOBIN="${D}/pkg/main/${PKG}.core.${PVRF}/bin"
mkdir -pv "$GOBIN"
go install -v github.com/KarpelesLab/hlsmaker@v${PV}
if [ ! -f "$GOBIN/hlsmaker" ]; then
	echo "Build failed"
	exit
fi

finalize
