#!/bin/sh
source "../../common/init.sh"

get https://github.com/pmem/ndctl/archive/refs/tags/v${PV}.tar.gz
acheck

inherit asciidoc

cd "${S}"

$(dirname $0)/git-version-gen
aautoreconf

cd "${T}"

importpkg sys-apps/keyutils sys-apps/util-linux dev-libs/json-c

# TODO fix asciidoc
doconf --disable-asciidoctor --without-systemd --disable-docs

make
make install DESTDIR="${D}"

finalize
