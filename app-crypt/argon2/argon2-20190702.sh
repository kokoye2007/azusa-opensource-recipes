#!/bin/sh
source "../../common/init.sh"

get https://github.com/P-H-C/phc-winner-argon2/archive/${PV}.tar.gz
acheck

cd "phc-winner-argon2-${PV}"

make PREFIX="/pkg/main/${PKG}.core.${PVRF}" LIBRARY_REL=lib$LIB_PREFIX
make install DESTDIR="${D}" PREFIX="/pkg/main/${PKG}.core.${PVRF}" LIBRARY_REL=lib$LIB_PREFIX

fixelf
organize

# fix pkgconfig
makepkgconfig '-largon2 -lrt -ldl' libargon2

archive
