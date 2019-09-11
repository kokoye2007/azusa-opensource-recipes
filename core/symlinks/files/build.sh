#!/bin/sh
set -e

DIRS="bin sbin pkgconfig info include"
MULTILIB=yes

cd $1
mkdir -p $DIRS
mkdir etc etc/ssl
ln -snf /pkg/main/app-misc.ca-certificates/etc/ssl/certs etc/ssl/certs

if [ $MULTILIB = yes ]; then
	mkdir lib32 lib64
	ln -s lib64 lib
	LIBS="lib64 lib32 lib"

	ln -s `realpath /pkg/main/sys-libs.glibc.core/lib64/ld-linux-x86-64.so.2` lib64
	ln -s `realpath /pkg/main/sys-libs.glibc.libs`/lib64/*.o lib64
	realpath /pkg/main/sys-libs.glibc.core/lib64 >etc/ld.so.conf
else
	LIBS=lib
	mkdir lib
fi

for pn in $(apkg-ctrl apkgdb/main?action=list | grep -v busybox | grep -v symlinks); do
	p=/pkg/main/${pn}
	if [ ! -d "${p}" ]; then
		continue
	fi

	for foo in $DIRS; do
		if [ -d "${p}/$foo" -a ! -L "${p}/$foo" ]; then
			cp -rsf "${p}/$foo"/* "$foo" || true
		fi
	done

	# check if third element of package name is "libs"
	if [ x`echo "$pn" | cut -d. -f3` = x"libs" ]; then
		for foo in $LIBS; do
			if [ -d "${p}/$foo" -a ! -L "${p}/$foo" ]; then
				echo "${p}/$foo" >>etc/ld.so.conf
			fi
		done
	fi

	if [ -d "${p}/man" ]; then
		for foo in "${p}/man"/*; do
			m=`basename "$foo"`
			mkdir -p "man/$m"
			ln -snf "$foo"/* "man/$m/"
		done
	fi

	echo $p
done

echo "Generating ld.so.cache..."
/pkg/main/sys-libs.glibc.core/sbin/ldconfig -X -C etc/ld.so.cache -f etc/ld.so.conf 
