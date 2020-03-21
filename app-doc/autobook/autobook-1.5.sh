#!/bin/sh
source "../../common/init.sh"

get https://sourceware.org/autobook/${P}.tar.gz

mkdir -p "${D}/pkg/main"

mv "${P}" "${D}/pkg/main/${PKG}.core.${PVRF}"

finalize
