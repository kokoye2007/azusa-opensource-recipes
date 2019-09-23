#!/bin/sh
set -e

DIRS="bin sbin pkgconfig info include"
MULTILIB=yes

cd $1
mkdir -p $DIRS
mkdir etc etc/ssl
ln -snf /pkg/main/app-misc.ca-certificates/etc/ssl/certs etc/ssl/certs

if [ $MULTILIB = yes ]; then
	mkdir -p lib32 lib64 full/lib32 full/lib64
	ln -s lib64 lib
	ln -s lib64 full/lib
	LIBS="lib64 lib32 lib"
	LIB=lib64

	ln -s `realpath /pkg/main/sys-libs.glibc.libs`/lib64/ld-linux-x86-64.so.2 lib64
	ln -s `realpath /pkg/main/sys-libs.glibc.libs`/lib64/*.o lib64
else
	LIBS=lib
	LIB=lib
	mkdir -p lib full/lib
fi

for pn in $(apkg-ctrl apkgdb/main?action=list | grep -v busybox | grep -v symlinks); do
	p=/pkg/main/${pn}
	t=`echo "$pn" | cut -d. -f3`

	if [ x"$t" = x"mod" ]; then
		# skip modules (python/etc)
		continue
	fi

	if [ ! -d "${p}" ]; then
		# not available?
		continue
	fi

	for foo in $DIRS; do
		if [ -d "${p}/$foo" -a ! -L "${p}/$foo" ]; then
			cp -rsf "${p}/$foo"/* "$foo" || true
		fi
	done

	# check if third element of package name is "libs"
	if [ x"$t" = x"libs" ]; then
		for foo in $LIBS; do
			if [ -d "${p}/$foo" -a ! -L "${p}/$foo" ]; then
				echo "${p}/$foo" >>etc/ld.so.conf.tmp
				# generate symlinks for full/lib64
				for bar in "${p}/$foo"/*.so*; do
					if [ -f "$bar" ]; then
						ln -snf "$bar" full/$foo
					fi
				done
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

realpath /pkg/main/sys-libs.glibc.libs/$LIB >>etc/ld.so.conf.tmp
tac etc/ld.so.conf.tmp >etc/ld.so.conf
rm etc/ld.so.conf.tmp

echo "Generating ld.so.cache..."
# reorg ld.so.conf the other way around
/pkg/main/sys-libs.glibc.core/sbin/ldconfig -X -C etc/ld.so.cache -f etc/ld.so.conf 
