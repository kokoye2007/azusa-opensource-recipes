#!/bin/sh

ARCH=`uname -m`
OS=`uname -s | tr A-Z a-z`

case $ARCH in
	x86_64)
		ARCH=amd64
		;;
esac


mkdir -p empty dist
mksquashfs empty "dist/core.base-root.0.1.0.${OS}.${ARCH}.squashfs" -all-root -nopad -noappend -pf base-root.txt
