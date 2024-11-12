#!/bin/sh
source "../../common/init.sh"

get https://github.com/pmem/"${PN}"/archive/refs/tags/v"${PV}".tar.gz
acheck

inherit asciidoc

cd "${S}" || exit

./git-version-gen
aautoreconf

cd "${T}" || exit

importpkg libkeyutils sys-apps/util-linux dev-libs/json-c

# TODO fix docs
doconf CFLAGS="${CPPFLAGS} -g -O2" --disable-asciidoctor --without-systemd --disable-docs

make
make install DESTDIR="${D}"

finalize
