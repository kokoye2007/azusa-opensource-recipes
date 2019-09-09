#!/bin/sh

# script to build a root directory for Azusa

BASE="$1"

if [ x"$BASE" = x -o ! -d "$BASE" ]; then
	echo "Usage: $0 directory"
	exit 1
fi

for foo in root sys proc etc etc/ssl dev dev/pts dev/shm tmp pkg usr usr/azusa usr/share home; do
	if [ ! -d "$BASE/$foo" ]; then
		mkdir "$BASE/$foo"
	fi
done

# fix modes for /tmp
chmod 1777 "$BASE/tmp"

for foo in bin sbin lib lib32 lib64; do
	ln -snf "/pkg/main/core.symlinks/$foo" "$BASE/$foo"
	ln -snf "/pkg/main/core.symlinks/$foo" "$BASE/usr/$foo"
done

for foo in man info; do
	ln -snf "/pkg/main/core.symlinks/$foo" "$BASE/usr/$foo"
done

for foo in ld.so.cache ld.so.conf; do
	ln -snf "/pkg/main/core.symlinks/etc/$foo" "$BASE/etc/$foo"
done

ln -snf /pkg/main/core.symlinks/pkgconfig "$BASE/usr/share/pkgconfig"
ln -snf /pkg/main/core.symlinks/include "$BASE/usr/include"

# install apkg
cp -f /pkg/main/core.apkg/apkg "$BASE/usr/azusa/apkg"

# initialize dev
if [ $USER = root ]; then
	mknod -m 600 "$BASE/dev/console" c 5 1
	mknod -m 666 "$BASE/dev/null" c 1 3
	mknod -m 666 "$BASE/dev/zero" c 1 5
	mknod -m 666 "$BASE/dev/ptmx" c 5 2
	mknod -m 666 "$BASE/dev/tty" c 5 0
	mknod -m 666 "$BASE/dev/fuse" c 10 229
	mknod -m 444 "$BASE/dev/random" c 1 8
	mknod -m 444 "$BASE/dev/urandom" c 1 9
	chown root:tty $BASE/dev/{console,ptmx,tty}
else
	echo "Not populating /dev (please run as root)"
fi

if [ ! -f "$BASE/etc/resolv.conf" ]; then
	echo "nameserver 8.8.8.8" >"$BASE/etc/resolv.conf"
	echo "nameserver 8.8.4.4" >>"$BASE/etc/resolv.conf"
fi
