#!/bin/sh
source "../../common/init.sh"

get http://mirror.postfix.jp/postfix-release/official/${P}.tar.gz
acheck

cd "${P}"

importpkg dev-db/lmdb dev-libs/cyrus-sasl sys-libs/db

sed -i -e "/^#define ALIAS_DB_MAP/s|:/etc/aliases|:/etc/mail/aliases|" src/util/sys_defs.h
# change default paths to better comply with standard paths
sed -i -e "s:/usr/local/:/usr/:g" conf/master.cf

PKG="sqlite3 openssl"

CFLAGS="-DHAS_PCRE -DHAS_MYSQL $(mysql_config --include) -DHAS_PGSQL -I$(pg_config --includedir) -DHAS_SQLITE -DHAS_LMDB -DUSE_SASL_AUTH -DUSE_CYRUS_SASL -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE"
LIBS="${LDFLAGS} -ldl -lpam -llmdb -lpthread"

AUXLIBS_LMDB="-llmdb -lpthread"
AUXLIBS_MYSQL="$(mysql_config --libs)"
AUXLIBS_PCRE="$(pcre-config --libs)"
AUXLIBS_PGSQL="-L$(pg_config --libdir) -lpq"
AUXLIBS_SQLITE="-lsqlite3 -lpthread"

make makefiles shared=yes dynamicmaps=no pie=yes shlib_directory="/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX/postfix/MAIL_VERSION" DEBUG="" OPT="-O2 ${CPPFLAGS}" CFLAGS="-O2 ${CPPFLAGS}" CCARGS="$CFLAGS" AUXLIBS="$LIBS" AUXLIBS_LMDB="${AUXLIBS_LMDB}" AUXLIBS_MYSQL="${AUXLIBS_MYSQL}" AUXLIBS_PCRE="${AUXLIBS_PCRE}" AUXLIBS_PGSQL="${AUXLIBS_PGSQL}" AUXLIBS_SQLITE="${AUXLIBS_SQLITE}"
make
make install install_root="${D}" config_directory="/etc/postfix" manpage_directory="/pkg/main/${PKG}.doc.${PVR}/man" command_directory="/pkg/main/${PKG}.core.${PVR}/sbin" mailq_path="/pkg/main/${PKG}.core.${PVR}/bin/mailq" newaliases_path="/pkg/main/${PKG}.core.${PVR}/bin/newaliases" sendmail_path="/pkg/main/${PKG}.core.${PVR}/bin/sendmail"
mv -v "${D}/etc/postfix" "/pkg/main/${PKG}.doc.${PVR}/etc"

finalize
