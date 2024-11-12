#!/bin/sh
source "../../common/init.sh"

get https://github.com/edenhill/"${PN}"/archive/refs/tags/v"${PV}".tar.gz
acheck

cd "${S}" || exit

doconflight --enable-zlib --enable-zstd --enable-ssl --enable-gssapi --enable-sasl --enable-lz4-ext --enable-lz4 --enable-regex-ext --enable-c11threads --enable-syslog

make
make install DESTDIR="${D}"

finalize
