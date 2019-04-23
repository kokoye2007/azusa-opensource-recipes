#!/bin/sh
set -e

DIRS="bin sbin lib pkgconfig lib32 lib64 info include"

cd $1
mkdir -p $DIRS
rmdir lib
ln -s lib64 lib
mkdir etc

for p in $(find /home/magicaltux/projects/tpkg-tools/repo/tpkg/dist/main/ -mindepth 2 -maxdepth 3 -type d -printf '%P\n' | grep -v busybox | grep -v symlinks); do
	p=/pkg/main/${p//\//.}
	if [ ! -d "${p}" ]; then
		continue
	fi


	for foo in $DIRS; do
		if [ -d "${p}/$foo" ]; then
			cp -rsf "${p}/$foo"/* "$foo" || true
			case $foo in
			lib*)
				realpath "${p}/$foo" >>etc/ld.so.conf
				;;
			esac
		fi
	done

	if [ -d "${p}/man" ]; then
		for foo in "${p}/man"/*; do
			m=`basename "$foo"`
			mkdir -p "man/$m"
			ln -snfv "$foo"/* "man/$m/"
		done
	fi

	echo $p
done

echo "Generating ld.so.cache..."
/pkg/main/sys-libs.glibc.core/sbin/ldconfig -X -C etc/ld.so.cache -f etc/ld.so.conf 
