#!/bin/bash

# script to build a root directory for Azusa

# See: https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard


BASE="$1"

if [ x"$BASE" = x -o ! -d "$BASE" ]; then
	echo "Usage: $0 directory"
	exit 1
fi

for foo in root sys proc etc etc/ssl dev dev/pts dev/shm tmp pkg usr usr/azusa usr/share home var var/run var/tmp boot mnt opt media; do
	if [ ! -d "$BASE/$foo" ]; then
		mkdir "$BASE/$foo"
	fi
done

# fix modes for /tmp
chmod 01777 "$BASE/tmp" "$BASE/var/tmp"
chmod 0750 "$BASE/root"

# configure /var
mkdir -p $BASE/var/{log,mail,spool,cache,lib/{color,misc,locate},lock}

# TODO multilib: limit lib64 to x86_64
for foo in bin sbin lib lib32 lib64; do
	ln -snf "/pkg/main/azusa.symlinks.core/$foo" "$BASE/$foo"
	ln -snf "/pkg/main/azusa.symlinks.core/$foo" "$BASE/usr/$foo"
done

ln -snf "/pkg/main/app-misc.ca-certificates/etc/ssl/certs" "$BASE/etc/ssl/certs"

for foo in man info; do
	ln -snf "/pkg/main/azusa.symlinks.core/$foo" "$BASE/usr/$foo"
done

for foo in ld.so.cache ld.so.conf; do
	ln -snf "/pkg/main/azusa.symlinks.core/etc/$foo" "$BASE/etc/$foo"
done

ln -snf /pkg/main/azusa.symlinks.core/pkgconfig "$BASE/usr/share/pkgconfig"
ln -snf /pkg/main/azusa.symlinks.core/include "$BASE/usr/include"
ln -snf /pkg/main/azusa.symlinks.core/share/gir-1.0 "$BASE/usr/share/gir-1.0"
ln -snf /pkg/main/x11-misc.shared-mime-info.core/share/mime "$BASE/usr/share/mime"

# install apkg
cp -fT /pkg/main/azusa.apkg.core/apkg "$BASE/usr/azusa/apkg"
cp -fT /pkg/main/azusa.init/init "$BASE/usr/azusa/azusa-init"
cp -fT /pkg/main/sys-apps.busybox.core/bin/busybox "$BASE/usr/azusa/busybox"

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

# populate /etc
find /pkg/main/azusa.baselayout.core/ -type f -printf '%P\n' | while read foo; do
	if [ ! -f "$BASE/$foo" ]; then
		# file is missing, copy it. But first...
		foo_dir=`dirname "$foo"`
		if [ ! -d "$BASE/$foo_dir" ]; then
			# make dir if missing
			mkdir -p "$BASE/$foo_dir"
		fi
		# then copy
		cp "/pkg/main/azusa.baselayout.core/$foo" "$BASE/$foo"
	fi
done

if [ ! -f "$BASE/etc/resolv.conf" ]; then
	echo "nameserver 8.8.8.8" >"$BASE/etc/resolv.conf"
	echo "nameserver 8.8.4.4" >>"$BASE/etc/resolv.conf"
fi

# touch stuff
touch "$BASE/var/run/utmp" "$BASE/var/log/"{btmp,lastlog,wtmp}
chmod 664 "$BASE/var/run/utmp" "$BASE/var/log/lastlog"
if [ $USER = root ]; then
	chgrp utmp "$BASE/var/run/utmp" "$BASE/var/log/lastlog"
fi
