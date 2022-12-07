#!/bin/sh
source "../../common/init.sh"

get https://gitlab.freedesktop.org/${PN}/${PN}/-/archive/${PV}/${P}.tar.gz
acheck

cd "${T}"

domeson -Dudev-dir=/lib/udev -Ddebug-gui=false -Dtests=false -Ddocumentation=false -Dlibwacom=false

finalize
