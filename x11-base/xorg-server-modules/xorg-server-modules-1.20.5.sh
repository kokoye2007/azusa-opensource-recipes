#!/bin/sh
source "../../common/init.sh"

cd "${T}"

TARGET="${D}/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX/xorg/modules"
mkdir -p "${TARGET}"

# copy original modules
cp -rsfT "/pkg/main/x11-base.xorg-server.mod.${PVR}/lib$LIB_SUFFIX/xorg/modules" "$TARGET"

# locate packages
for pn in `curl -s http://localhost:100/apkgdb/main?action=list | grep "^x11-"`; do
	p=/pkg/main/${pn}
	b=`echo "$pn" | cut -d. -f1-2`
	t=`echo "$pn" | cut -d. -f3`

	if [ $b = "x11-base.xorg-server-modules" ]; then
		continue
	fi

	if [ "$t" = "dev" ]; then
		continue
	fi

	if [ -d "${p}/lib$LIB_SUFFIX/xorg/modules" -a ! -L "${p}/lib$LIB_SUFFIX/xorg/modules" ]; then
		# copy
		echo " * Module: $pn"
		cp -rsfT "${p}/lib$LIB_SUFFIX/xorg/modules" "${TARGET}"
	fi
done

archive
