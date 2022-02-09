#!/bin/sh
source "../../common/init.sh"
envcheck
# do not use acheck so we keep networking

GOBIN="${D}/pkg/main/${PKG}.core.${PVRF}/bin"
mkdir -pv "$GOBIN"
go install -v github.com/0xPolygon/polygon-edge@v${PV}

finalize
