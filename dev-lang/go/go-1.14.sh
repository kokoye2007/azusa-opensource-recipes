#!/bin/sh
source "../../common/init.sh"

get https://dl.google.com/${PN}/go${PV}.src.tar.gz

cd "go/src"

export GOOS=linux
export GOARCH=amd64
export GOROOT_FINAL="/pkg/main/${PKG}.dev.${PVR}"
export GOROOT="${D}/pkg/main/${PKG}.dev.${PVR}"

./all.bash

# install
cd ../..
mkdir -p "${D}/pkg/main/"
mv go "${D}/pkg/main/${PKG}.dev.${PVR}"

finalize
