#!/bin/sh

set -e

# create a virtual azusa env with writable /pkg/main

if [ `cat /proc/filesystems | grep -c overlay` -eq 0 ]; then
	echo "You need overlay filesystem to run this"
	exit 1
fi

tmp_dir=$(mktemp -d -t azusa-XXXXXXXXXX)
chmod 0755 "$tmp_dir"

unset LC_ALL LANG TMPDIR

echo "Temporary environment is in $tmp_dir"

# initialize root
/pkg/main/core.symlinks.core/azusa/makeroot.sh "$tmp_dir"

# mount stuff
mkdir "$tmp_dir/pkg/main" "$tmp_dir/build" "$tmp_dir/.pkg-main-rw" "$tmp_dir/.pkg-main-work"
mount -t overlay overlay -o lowerdir=/pkg/main,upperdir="$tmp_dir/.pkg-main-rw",workdir="$tmp_dir/.pkg-main-work" "$tmp_dir/pkg/main"
mount -t proc proc "$tmp_dir/proc"
mkdir -p "$tmp_dir/dev/shm"
mount -o mode=1777 -t tmpfs tmpfs "$tmp_dir/dev/shm"
chroot "$tmp_dir" /bin/sh -c "dbus-uuidgen --ensure=/etc/machine-id" || true

cleanuptmp() {
	echo "Cleaning up $tmp_dir"
	umount "$tmp_dir/proc" || true
	umount "$tmp_dir/pkg/main" || true
	umount "$tmp_dir/dev/shm" || true
	rm -fr "$tmp_dir"
}
trap cleanuptmp EXIT
