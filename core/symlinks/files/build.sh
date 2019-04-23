#!/bin/sh
set -e

DIRS="bin sbin lib pkgconfig lib32 lib64 info include"

cd $1
mkdir -p $DIRS
rmdir lib
ln -s lib64 lib

for p in $(find /home/magicaltux/projects/tpkg-tools/repo/tpkg/dist/main/ -mindepth 2 -maxdepth 3 -type d -printf '%P\n' | grep -v busybox | grep -v symlinks); do
	p=/pkg/main/${p//\//.}
	if [ ! -d "${p}" ]; then
		continue
	fi

	for foo in $DIRS; do
		if [ -d "${p}/$foo" ]; then
			ln -snfv "${p}/$foo"/* "$foo/"
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
