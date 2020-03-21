#!/bin/sh
source "../../common/init.sh"

get https://hewlettpackard.github.io/wireless-tools/wireless_tools.${PV}.tar.gz
acheck

cd "$S"

make
make install PREFIX="${D}/pkg/main/${PKG}.core.${PVRF}"

finalize
