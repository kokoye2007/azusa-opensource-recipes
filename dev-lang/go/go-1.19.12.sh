#!/bin/sh
source "../../common/init.sh"

get https://dl.google.com/${PN}/go${PV}.src.tar.gz

cd "go/src"

export GOOS="${OS}"
export GOARCH="${ARCH}"
export GOROOT_FINAL="/pkg/main/${PKG}.dev.${PVRF}"
export GOROOT="${D}/pkg/main/${PKG}.dev.${PVRF}"
export PATH="/pkg/main/dev-lang.go.dev/bin/:$PATH"
if [ x"$ARCH" = x"386" ]; then
	export CGO_CFLAGS=-fno-stack-protector # https://github.com/golang/go/issues/54313
fi

./all.bash

# install
cd ../..
mkdir -p "${D}/pkg/main/"
mv go "${D}/pkg/main/${PKG}.dev.${PVRF}"

finalize
