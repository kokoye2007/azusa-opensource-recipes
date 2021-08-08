#!/bin/sh
source "../../common/init.sh"

TZ=`date +%Y%m%d`
MY_PVR="${PVR}.${TZ}.${OS}.${ARCH}"

mkdir -p "${D}/pkg/main/${PKG}.data.${MY_PVR}"
cd "${D}/pkg/main/${PKG}.data.${MY_PVR}"

# possible libs directories
LIBS="lib lib32 lib64"

mkdir etc

for pn in $(curl -s http://localhost:100/apkgdb/main?action=list | grep -v busybox | grep libs); do
	p=/pkg/main/${pn}
	t=`echo "$pn" | cut -d. -f3`
	if [ $t != "libs" ]; then
		continue
	fi
	echo -ne "\rScanning: $pn\033[K"
	for foo in $LIBS; do
		if [ -d "${p}/$foo" -a ! -L "${p}/$foo" ]; then
			echo "${p}/$foo" >>etc/ld.so.conf.tmp
		fi
	done
done
# reverse order in ld.so.conf so newer versions are on top and taken in priority
tac etc/ld.so.conf.tmp >etc/ld.so.conf
rm etc/ld.so.conf.tmp

echo "Generating ld.so.cache..."
/pkg/main/sys-libs.glibc.core/sbin/ldconfig -X -C etc/ld.so.cache -f etc/ld.so.conf

archive
