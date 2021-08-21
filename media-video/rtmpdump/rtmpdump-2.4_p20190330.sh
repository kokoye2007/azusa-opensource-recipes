#!/bin/sh
source "../../common/init.sh"

get http://git.ffmpeg.org/gitweb/rtmpdump.git/snapshot/c5f04a58fc2aeea6296ca7c44ee4734c18401aa3.tar.gz
acheck

cd "${S}"

apatch "$FILESDIR/rtmpdump-openssl-1.1-v2.patch"

sed -i -e 's:OPT=:&-fPIC :' -e 's:OPT:OPTS:' -e 's:CFLAGS=.*:& $(OPT):' librtmp/Makefile
sed -i -e 's/^LIBS=/LIBS=$(LDFLAGS) /' Makefile

importpkg openssl zlib

make prefix="${D}/pkg/main/${PKG}.core.${PVRF}" LDFLAGS="${LDFLAGS}"
make install prefix="${D}/pkg/main/${PKG}.core.${PVRF}"

finalize
