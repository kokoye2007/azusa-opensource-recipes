#!/bin/sh
source "../../common/init.sh"

get https://dl.google.com/${PN}/go${PV}.src.tar.gz

cd "go/src"

export GOOS="${OS}"
export GOARCH="${ARCH}"
export GOROOT_FINAL="/pkg/main/${PKG}.dev.${PVRF}"
export GOROOT="${D}/pkg/main/${PKG}.dev.${PVRF}"
export PATH="/pkg/main/dev-lang.go.dev/bin/:$PATH"

./all.bash

# install
cd ../..
mkdir -p "${D}/pkg/main/"
mv go "${D}/pkg/main/${PKG}.dev.${PVRF}"

finalize
