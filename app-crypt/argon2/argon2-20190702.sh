#!/bin/sh
source "../../common/init.sh"

get https://github.com/P-H-C/phc-winner-argon2/archive/${PV}.tar.gz
acheck

cd "phc-winner-argon2-${PV}"

# TODO fix libargon2.pc (needed by php 8.1+)
/bin/bash -i

make PREFIX="/pkg/main/${PKG}.core.${PVRF}" LIBRARY_REL=lib$LIB_PREFIX
make install DESTDIR="${D}" PREFIX="/pkg/main/${PKG}.core.${PVRF}" LIBRARY_REL=lib$LIB_PREFIX

finalize
