#!/bin/bash

# script to build a root directory for Azusa

# See: https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard

BASE="$1"

if [ "$BASE" = "" -o ! -d "$BASE" ]; then
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
mkdir -p "$BASE"/var/{log,mail,spool,cache,lib/{color,misc,locate},lock}

# TODO multilib: limit lib64 to x86_64
for foo in bin sbin lib lib32 lib64; do
	ln -snf "/pkg/main/azusa.symlinks.core.linux.__ARCH__/$foo" "$BASE/$foo"
	ln -snf "/pkg/main/azusa.symlinks.core.linux.__ARCH__/$foo" "$BASE/usr/$foo"
done

ln -snf "/pkg/main/app-misc.ca-certificates.core.linux.__ARCH__/etc/ssl/certs" "$BASE/etc/ssl/certs"

for foo in man info; do
	ln -snf "/pkg/main/azusa.symlinks.core.linux.__ARCH__/$foo" "$BASE/usr/$foo"
done

for foo in xml; do
	ln -snf "/pkg/main/azusa.symlinks.core.linux.__ARCH__/etc/$foo" "$BASE/etc/$foo"
done

for foo in ld.so.cache ld.so.conf; do
	ln -snf "/pkg/main/azusa.ldso.data.linux.__ARCH__/etc/$foo" "$BASE/etc/$foo"
done

ln -snfT /pkg/main/azusa.symlinks.core.linux.__ARCH__/pkgconfig "$BASE/usr/share/pkgconfig"
ln -snfT /pkg/main/azusa.symlinks.core.linux.__ARCH__/share/gir-1.0 "$BASE/usr/share/gir-1.0"
ln -snfT /pkg/main/azusa.symlinks.core.linux.__ARCH__/share/dbus-1 "$BASE/usr/share/dbus-1"
ln -snfT /pkg/main/x11-misc.shared-mime-info.core.linux.__ARCH__/share/mime "$BASE/usr/share/mime"
ln -snfT /pkg/main/azusa.fontcache.data.symlinks.linux.__ARCH__ "$BASE/usr/share/fonts"
ln -snfT /pkg/main/azusa.fontcache.data.cache.linux.__ARCH__/fontconfig "$BASE/var/cache/fontconfig"

# install apkg
cp -fT /pkg/main/azusa.apkg.core.linux.__ARCH__/apkg "$BASE/usr/azusa/apkg"
cp -fT /pkg/main/azusa.init.core.linux.__ARCH__/init "$BASE/usr/azusa/azusa-init"
cp -fT /pkg/main/sys-apps.busybox.core.linux.__ARCH__/bin/busybox "$BASE/usr/azusa/busybox"

# initialize dev
if [ "$(id -u)" -eq 0 ]; then
	mknod -m 600 "$BASE/dev/console" c 5 1
	mknod -m 666 "$BASE/dev/null" c 1 3
	mknod -m 666 "$BASE/dev/zero" c 1 5
	mknod -m 666 "$BASE/dev/ptmx" c 5 2
	mknod -m 666 "$BASE/dev/tty" c 5 0
	mknod -m 666 "$BASE/dev/fuse" c 10 229
	mknod -m 444 "$BASE/dev/random" c 1 8
	mknod -m 444 "$BASE/dev/urandom" c 1 9
	chown root:tty "$BASE"/dev/{console,ptmx,tty}
else
	echo "Not populating /dev (please run as root)"
fi

# populate /etc
find /pkg/main/azusa.baselayout.core.linux.__ARCH__/ '(' -type f -o -type l ')' -printf '%P\n' | while read foo; do
	if [ ! -f "$BASE/$foo" ]; then
		# file is missing, copy it. But first...
		foo_dir=$(dirname "$foo")
		if [ ! -d "$BASE/$foo_dir" ]; then
			# make dir if missing
			mkdir -p "$BASE/$foo_dir"
		fi
		# then copy
		cp -a "/pkg/main/azusa.baselayout.core.linux.__ARCH__/$foo" "$BASE/$foo"
	fi
done

if [ ! -f "$BASE/etc/resolv.conf" ]; then
	echo "nameserver 8.8.8.8" >"$BASE/etc/resolv.conf"
	echo "nameserver 8.8.4.4" >>"$BASE/etc/resolv.conf"
fi

# protect shadow
chmod 0600 "$BASE/etc/shadow"

# touch stuff
touch "$BASE/var/run/utmp" "$BASE/var/log/"{btmp,lastlog,wtmp}
chmod 664 "$BASE/var/run/utmp" "$BASE/var/log/lastlog"
if [ "$(id -u)" -eq 0 ]; then
	chgrp utmp "$BASE/var/run/utmp" "$BASE/var/log/lastlog"
fi
