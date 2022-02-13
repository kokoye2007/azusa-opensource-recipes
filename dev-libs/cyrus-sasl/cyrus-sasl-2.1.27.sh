#!/bin/sh
source "../../common/init.sh"

get https://github.com/cyrusimap/cyrus-sasl/releases/download/${P}/${P}.tar.gz
acheck

cd "${T}"

importpkg zlib libcrypt

doconf --with-dblib=gdbm --with-gdbm=/pkg/main/sys-libs.gdbm.dev --with-openssl=/pkg/main/dev-libs.openssl.dev --with-pam=/pkg/main/sys-libs.pam.dev --with-mysql=/pkg/main/dev-db.mariadb.dev --with-pgsql=/pkg/main/dev-db.postgres.dev --with-sqlite3=/pkg/main/dev-db.sqlite.dev

make
make install DESTDIR="${D}"

finalize
