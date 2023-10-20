#!/bin/sh
source "../../common/init.sh"

get https://github.com/libfuse/libfuse/releases/download/${P}/${P}.tar.gz
acheck

cd "${S}"

# disable examples
echo -n >example/meson.build

cd "${T}"

domeson -Duseroot=false
# -Dudevrulesdir="/path/to/udev/rules.d"

finalize
