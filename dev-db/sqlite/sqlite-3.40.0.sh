#!/bin/sh
source "../../common/init.sh"

SRC_PV="$(printf "%u%02u%02u%02u" $(echo "$PV" | tr '.' ' '))"
get https://sqlite.org/2022/sqlite-autoconf-$SRC_PV.tar.gz
acheck

cd "${T}"

importpkg zlib

doconf --disable-static --enable-fts5 CFLAGS="-g -O2 -DSQLITE_ENABLE_FTS3=1 -DSQLITE_ENABLE_FTS4=1 -DSQLITE_ENABLE_COLUMN_METADATA=1 -DSQLITE_ENABLE_UNLOCK_NOTIFY=1 -DSQLITE_ENABLE_DBSTAT_VTAB=1 -DSQLITE_SECURE_DELETE=1 -DSQLITE_ENABLE_FTS3_TOKENIZER=1"

make
make install DESTDIR="${D}"

finalize
