#!/bin/sh
source "../../common/init.sh"

get https://github.com/P-H-C/phc-winner-argon2/archive/${PV}.tar.gz
acheck

cd "phc-winner-argon2-${PV}"

make
make install DESTDIR="${D}" PREFIX="/pkg/main/${PKG}.core.${PVR}" LIBRARY_REL=lib$LIB_PREFIX

finalize
