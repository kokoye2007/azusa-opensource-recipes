#!/bin/sh
source "../../common/init.sh"

get https://sourceforge.net/projects/giflib/files/"${P}".tar.gz
acheck

cd "${P}" || exit

make
make install PREFIX="${D}/pkg/main/${PKG}.core.${PVRF}"

finalize
