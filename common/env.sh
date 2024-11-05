#!/bin/sh

set -e

source "common/arch.sh"

# create a virtual azusa env with writable /pkg/main

if [ $(cat /proc/filesystems | grep -c overlay) -eq 0 ]; then
	echo "You need overlay filesystem to run this"
	exit 1
fi

tmp_dir=$(mktemp -d -t azusa-XXXXXXXXXX)
chmod 0755 "$tmp_dir"

unset LC_ALL LANG TMPDIR
export LC_ALL=C.utf8

echo "Temporary environment is in $tmp_dir ARCH=$ARCH"

# initialize root
/pkg/main/azusa.symlinks.core.linux."${ARCH}"/azusa/makeroot.sh "$tmp_dir"

# mount stuff
mkdir "$tmp_dir/pkg/main" "$tmp_dir/build" "$tmp_dir/.pkg-main-rw" "$tmp_dir/.pkg-main-work"
mount -t overlay overlay -o lowerdir=/pkg/main,upperdir="$tmp_dir/.pkg-main-rw",workdir="$tmp_dir/.pkg-main-work" "$tmp_dir/pkg/main"
mount -t proc proc "$tmp_dir/proc"
mkdir -p "$tmp_dir/dev/shm" "$tmp_dir/dev/pts" "$tmp_dir/run"
mount -o mode=1777 -t tmpfs tmpfs "$tmp_dir/dev/shm"
mount -t devpts devpts "$tmp_dir/dev/pts"
chroot "$tmp_dir" /bin/sh -c "dbus-uuidgen --ensure=/etc/machine-id" || true

cleanuptmp() {
	echo "Cleaning up $tmp_dir"
	umount "$tmp_dir/proc" || umount -l "$tmp_dir/proc" || true
	umount "$tmp_dir/pkg/main" || umount -l "$tmp_dir/pkg/main" || true
	umount "$tmp_dir/dev/shm" || umount -l "$tmp_dir/dev/shm" || true
	umount "$tmp_dir/dev/pts" || umount -l "$tmp_dir/dev/pts" || true
	rm -fr "$tmp_dir"
}
trap cleanuptmp EXIT
