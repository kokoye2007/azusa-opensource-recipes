#!/bin/sh
source "../../common/init.sh"

get https://sqlite.org/2019/sqlite-autoconf-3290000.tar.gz

cd "${T}"

doconf --disable-static --enable-fts5 CFLAGS="-g -O2 -DSQLITE_ENABLE_FTS3=1 -DSQLITE_ENABLE_FTS4=1 -DSQLITE_ENABLE_COLUMN_METADATA=1 -DSQLITE_ENABLE_UNLOCK_NOTIFY=1 -DSQLITE_ENABLE_DBSTAT_VTAB=1 -DSQLITE_SECURE_DELETE=1 -DSQLITE_ENABLE_FTS3_TOKENIZER=1"

make
make install DESTDIR="${D}"

finalize
