#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/"${PN}"/"${P}".tar.gz
acheck

cd "${S}" || exit

# make it possible for -lm to work
export VPATH="/pkg/main/sys-libs.glibc.libs/lib$LIB_SUFFIX"

make env=yes
make install DESTDIR="${D}" prefix="/pkg/main/${PKG}.core.${PVRF}"

finalize
