#!/bin/sh
source "../../common/init.sh"

get https://github.com/LMDB/lmdb/archive/LMDB_"${PV}".tar.gz
acheck

cd "lmdb-LMDB_${PV}/libraries/liblmdb" || exit

make
sed -i 's| liblmdb.a||' Makefile

make prefix="${D}/pkg/main/${PKG}.core.${PVRF}" install

finalize
