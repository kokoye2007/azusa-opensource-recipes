#!/bin/sh
source "../../common/init.sh"

get https://github.com/pmem/ndctl/archive/refs/tags/v"${PV}".tar.gz
acheck

inherit asciidoc

cd "${S}" || exit

$(dirname "$0")/git-version-gen

cd "${T}" || exit

importpkg sys-apps/keyutils sys-apps/util-linux dev-libs/json-c dev-libs/iniparser

# TODO fix asciidoc
domeson -Drootprefix="/" -Dasciidoctor=disabled -Dsystemd=disabled -Diniparserdir=/pkg/main/dev-libs.iniparser.dev/include

finalize
