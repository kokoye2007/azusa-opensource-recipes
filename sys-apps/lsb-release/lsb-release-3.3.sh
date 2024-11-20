#!/bin/sh
source "../../common/init.sh"

get https://github.com/thkukuk/lsb-release_os-release/archive/refs/tags/v${PV}.tar.gz
acheck

cd "${S}"

# POSIX compat
sed -i -e 's:--long:-l:g' lsb_release

make prefix="${D}/pkg/main/${PKG}.core.${PVRF}" install

finalize
