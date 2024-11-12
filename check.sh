#!/bin/bash
ROOTDIR="$(pwd)"
source "common/init.sh"
cd "$ROOTDIR" || exit

for foo in */*; do
	if [ ! -d "$foo" ]; then
		continue
	fi

	# check if this exists
	p="/pkg/main/${foo/\//.}"

	if [ -L "$p.core.${OS}.${ARCH}" ]; then
		continue
	fi
	if [ -L "$p.libs.${OS}.${ARCH}" ]; then
		continue
	fi
	if [ -L "$p.fonts.${OS}.${ARCH}" ]; then
		continue
	fi
	if [ -L "$p.data.${OS}.${ARCH}" ]; then
		continue
	fi
	if [ -L "$p.mod.${OS}.${ARCH}" ]; then
		continue
	fi
	echo "not found: $foo"
done
