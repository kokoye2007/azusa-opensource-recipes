#!/bin/sh

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
	ln -snf "/pkg/main/core.symlinks/$foo" "$BASE/$foo"
	ln -snf "/pkg/main/core.symlinks/$foo" "$BASE/usr/$foo"
done

ln -snf "/pkg/main/app-misc.ca-certificates/etc/ssl/certs" "$BASE/etc/ssl/certs"

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

if [ ! -f "$BASE/etc/passwd" ]; then
	echo "root:x:0:0:root:/root:/bin/bash" >"$BASE/etc/passwd"
fi

if [ ! -f "$BASE/etc/os-release" ]; then
	echo "NAME=Azusa" >"$BASE/etc/os-release"
	echo "ID=azusa" >>"$BASE/etc/os-release"
	echo "PRETTY_NAME=Azusa" >>"$BASE/etc/os-release"
	echo "HOME_URL=\"https://www.azusa.jp/\"" >>"$BASE/etc/os-release"
	#ANSI_COLOR="1;32"
	#SUPPORT_URL="https://www.gentoo.org/support/"
	#BUG_REPORT_URL="https://bugs.gentoo.org/"
fi

if [ ! -f "$BASE/etc/group" ]; then
	cat >"$BASE/etc/group" <<"EOF"
root:x:0:
bin:x:1:
sys:x:2:
kmem:x:3:
tty:x:4:
tape:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
man:x:15:
wheel:x:16:
news:x:17:
uucp:x:18:
console:x:19:
cdrom:x:20:
cdrw:x:21:
input:x:22:
nogroup:x:65533:
nobody:x:65534:
EOF
fi

# touch/etc
touch "$BASE/var/run/utmp" "$BASE/var/log/"{btmp,lastlog,wtmp}
chmod 664 "$BASE/var/run/utmp" "$BASE/var/log/lastlog"
if [ $USER = root ]; then
	chgrp utmp "$BASE/var/run/utmp" "$BASE/var/log/lastlog"
fi
