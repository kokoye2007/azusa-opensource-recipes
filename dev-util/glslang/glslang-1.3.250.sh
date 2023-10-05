#!/bin/sh
source "../../common/init.sh"

SNAPSHOT_COMMIT="sdk-${PV}.0"
get https://github.com/KhronosGroup/${PN}/archive/${SNAPSHOT_COMMIT}.tar.gz ${P}.tar.gz
acheck

cd "${T}"

docmake -DENABLE_PCH=OFF

finalize
