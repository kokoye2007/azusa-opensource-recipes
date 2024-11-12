#!/bin/sh
source "../../common/init.sh"

get http://www.haproxy.org/download/"${PV%.*}"/src/"${P}".tar.gz
acheck

cd "${P}" || exit

importpkg dev-lang/lua openssl libpcre zlib libxcrypt

make TARGET=linux-glibc USE_OPENSSL=1 USE_ZLIB=1 USE_LUA=1 USE_PCRE=1 LUA_LIB_NAME=lua CFLAGS="${CPPFLAGS} -O2" LDFLAGS="${LDFLAGS}"
make install DESTDIR="${D}" PREFIX="/pkg/main/${PKG}.core.${PVRF}"

finalize
