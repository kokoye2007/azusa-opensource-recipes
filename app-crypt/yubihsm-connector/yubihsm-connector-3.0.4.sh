#!/bin/sh
source "../../common/init.sh"

get https://developers.yubico.com/yubihsm-connector/Releases/"${P}".tar.gz
envcheck
# do not use acheck so we keep networking

cd "${S}" || exit

export PATH="/pkg/main/dev-lang.go.dev/bin:$PATH"

echo -n "Using: "
go version

make gen

export GOBIN="${D}/pkg/main/${PKG}.core.${PVRF}/bin"
mkdir -pv "$GOBIN"
go install -v .
if [ ! -f "$GOBIN/yubihsm-connector" ]; then
	echo "Build failed"
	exit
fi

finalize
