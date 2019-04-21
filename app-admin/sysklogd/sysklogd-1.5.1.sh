#!/bin/sh
source "../../common/init.sh"

get http://www.infodrom.org/projects/sysklogd/download/${P}.tar.gz

sed -i '/Error loading kernel symbols/{n;n;d}' ${P}/ksym_mod.c
sed -i 's/union wait/int/' ${P}/syslogd.c

cd "${P}"

make 

mkdir -p "${D}/pkg/main/${PKG}.core.${PVR}/sbin" "${D}/pkg/main/${PKG}.doc.${PVR}/man"/man{5,8}
make install BINDIR="${D}/pkg/main/${PKG}.core.${PVR}/sbin" MANDIR="${D}/pkg/main/${PKG}.doc.${PVR}/man" MAN_USER=`id -u` MAN_GROUP=`id -g`

finalize
