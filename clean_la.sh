#!/bin/sh
set -e

if [ `id -u` != 0 ]; then
	echo "Please run as root"
	exit
fi

mkdir /tmp/apkg || true

for pn in $(curl -s http://localhost:100/apkgdb/main?action=list | grep -v symlinks); do
	echo -ne "\rScanning: $pn\033[K"
	p=/pkg/main/${pn}
	t=`echo "$pn" | cut -d. -f3`

	CNT=`find "$p" -name '*.la' | wc -l`
	if [ "$CNT" -eq 0 ]; then
		continue
	fi

	echo -e "\rFound in: $p\033[K"

	mkdir /tmp/clean
	rsync -a "$p/" "/tmp/clean/"
	find /tmp/clean -name '*.la' -delete

	# make new squashfs
	mksquashfs "/tmp/clean/" "/tmp/apkg/${pn}.squashfs" -nopad -noappend

	rm -fr "/tmp/clean"
done
