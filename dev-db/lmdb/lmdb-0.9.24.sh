#!/bin/sh
source "../../common/init.sh"

get https://github.com/LMDB/lmdb/archive/LMDB_${PV}.tar.gz

cd "lmdb-LMDB_${PV}/libraries/liblmdb"

make
sed -i 's| liblmdb.a||' Makefile

make prefix="${D}/pkg/main/${PKG}.core.${PVR}" install

finalize
