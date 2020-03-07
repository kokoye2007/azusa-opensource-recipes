#!/bin/sh
source "../../common/init.sh"

get https://registry.npmjs.org/${PN}/-/${P}.tgz
acheck

npm install -g --prefix "${D}/pkg/main/${PKG}.core.${PVR}" "${P}.tgz"

finalize
