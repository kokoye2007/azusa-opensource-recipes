#!/bin/bash
source "../../common/init.sh"

TZ=`date +%Y%m%d`
MY_PVR="${PVR}.${TZ}.${OS}.${ARCH}"

mkdir -p "${D}/pkg/main/${PKG}.data.${MY_PVR}"
cd "${D}/pkg/main/${PKG}.data.${MY_PVR}"

# possible libs directories
LIBS="lib lib32 lib64"

mkdir etc
ln -s /pkg/main/sys-libs.glibc.dev/etc/rpc etc/rpc

scanlibs() {
	for pn in $(curl -s "http://localhost:100/apkgdb/main?action=list&sub=$1" | grep -v busybox | grep libs); do
		p=/pkg/main/${pn}
		t=`echo "$pn" | cut -d. -f3`
		if [ $t != "libs" ]; then
			continue
		fi
		echo -ne "\rScanning: $pn\033[K"
		if [ ! -f "${p}/.ld.so.cache" ]; then
			echo -e "\rMissing ld config file: $pn"
		fi
		for foo in $LIBS; do
			if [ -d "${p}/$foo" -a ! -L "${p}/$foo" ]; then
				echo "${p}/$foo" >>etc/ld.so.conf.tmp
			fi
		done
	done
}

case $ARCH in
	amd64)
		# amd64 → also scan 32bits libs (scan first so they are lower priority)
		scanlibs "${OS}.386"
		;;
esac

scanlibs "${OS}.${ARCH}"

# reverse order in ld.so.conf so newer versions are on top and taken in priority
tac etc/ld.so.conf.tmp >etc/ld.so.conf
rm etc/ld.so.conf.tmp

echo
echo "Generating ld.so.cache..."
if [ -f /pkg/main/sys-libs.glibc.core/sbin/ldconfig ]; then
	/pkg/main/sys-libs.glibc.core/sbin/ldconfig -X -C etc/ld.so.cache -f etc/ld.so.conf
else
	# can't be helped...?
	ldconfig -X -C etc/ld.so.cache -f etc/ld.so.conf
fi

archive
