#!/bin/sh
source "../../common/init.sh"

get https://nmap.org/dist/"${P}".tgz
acheck

importpkg zlib dev-libs/libpcre sys-libs/glibc dev-libs/openssl net-libs/libpcap net-libs/libssh2 dev-lang/lua dev-libs/liblinear

cd "${S}" || exit

# overwrite nbase/getopt.h so build works
cp -fv /pkg/main/sys-libs.glibc.dev/include/getopt.h nbase/getopt.h

export PYTHON=python3

doconf --without-zenmap

make
make install DESTDIR="${D}"

fixelf
archive
