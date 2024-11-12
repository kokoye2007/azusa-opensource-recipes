#!/bin/sh
source "../../common/init.sh"

get https://github.com/KarpelesLab/"${PN}"/archive/refs/tags/v"${PV}".tar.gz
acheck

cd "${S}" || exit

make CC=musl-gcc
make install PREFIX="/pkg/main/${PKG}.core.${PVRF}" DESTDIR="${D}"

finalize
