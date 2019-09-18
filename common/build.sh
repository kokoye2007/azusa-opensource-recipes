#!/bin/bash
set -e

# Compile a given package ($1) within a jail
PKG="$1"
PKG_DIR=`dirname "$PKG"`
PKG_SCRIPT=`basename "$PKG"`

if [ `cat /proc/filesystems | grep -c overlay` -eq 0 ]; then
	echo "You need overlay filesystem to run this"
	exit 1
fi

echo "Preparing to build $PKG"

tmp_dir=$(mktemp -d -t apkg-XXXXXXXXXX)

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

echo "Fetching azusa-opensource-recipes ..."

chroot "$tmp_dir" /bin/bash -c "cd /root; git clone -q https://github.com/AzusaOS/azusa-opensource-recipes.git"

echo "Build..."

chroot "$tmp_dir" /bin/bash -c "cd /root/azusa-opensource-recipes/${PKG_DIR}; ./${PKG_SCRIPT}"

mkdir /tmp/apkg || true
mv -v "$tmp_dir/tmp/apkg"/* /tmp/apkg

# fix rights on /tmp/apkg to make sure user can upload
chown 1000 -R /tmp/apkg
