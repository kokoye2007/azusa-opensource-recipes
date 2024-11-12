#!/bin/sh
source "../../common/init.sh"

get https://github.com/libfuse/libfuse/releases/download/"${P}"/"${P}".tar.gz
acheck

cd "${S}" || exit

# disable examples
echo -n >example/meson.build

cd "${T}" || exit

domeson -Duseroot=false
# -Dudevrulesdir="/path/to/udev/rules.d"

finalize
