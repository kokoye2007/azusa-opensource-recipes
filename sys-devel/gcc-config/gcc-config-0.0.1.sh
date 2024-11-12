#!/bin/sh
source "../../common/init.sh"

TZ=$(date +%Y%m%d)
MY_PVR="${PVR}.${TZ}.${OS}.${ARCH}"

mkdir -p "${D}/pkg/main/${PKG}.core.${MY_PVR}"
cd "${D}/pkg/main/${PKG}.core.${MY_PVR}" || exit

mkdir gcc-config
for pn in $(curl -s http://localhost:100/apkgdb/main?action=list | grep ^sys-devel.gcc.dev); do
	CFG="/pkg/main/${pn}/gcc-config"
	if [ ! -d "$CFG" ]; then
		continue
	fi
	cp -vf "$CFG"/* gcc-config
done

archive
