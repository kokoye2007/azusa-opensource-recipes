#!/bin/sh

set -e

# create a virtual azusa env with writable /pkg/main

if [ `cat /proc/filesystems | grep -c overlay` -eq 0 ]; then
	echo "You need overlay filesystem to run this"
	exit 1
fi

tmp_dir=$(mktemp -d -t azusa-XXXXXXXXXX)
chmod 0755 "$tmp_dir"

echo "Temporary environment is in $tmp_dir"

# initialize root
/pkg/main/core.symlinks/azusa/makeroot.sh "$tmp_dir"

# mount stuff
mkdir "$tmp_dir/pkg/main" "$tmp_dir/build" "$tmp_dir/.pkg-main-rw" "$tmp_dir/.pkg-main-work"
mount -t overlay overlay -o lowerdir=/pkg/main,upperdir="$tmp_dir/.pkg-main-rw",workdir="$tmp_dir/.pkg-main-work" "$tmp_dir/pkg/main"
mount -t proc proc "$tmp_dir/proc"

cleanuptmp() {
	echo "Cleaning up $tmp_dir"
	umount "$tmp_dir/proc" || true
	umount "$tmp_dir/pkg/main" || true
	rm -fr "$tmp_dir"
}
trap cleanuptmp EXIT
