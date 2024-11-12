#!/bin/sh
source "../../common/init.sh"

get https://www.musl-libc.org/releases/"${P}".tar.gz
acheck

cd "${T}" || exit

# we install musl in a subdirectory to avoid headers from conflicting with glibc
callconf --prefix=/pkg/main/"${PKG}".dev."${PVRF}"/musl --exec-prefix=/pkg/main/"${PKG}".core."${PVRF}" --syslibdir=/pkg/main/"${PKG}".dev."${PVRF}"/lib"$LIB_SUFFIX" --enable-wrapper=all

make -j"$NPROC"
make install DESTDIR="${D}"

finalize
