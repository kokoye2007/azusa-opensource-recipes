#!/bin/sh

KVER="$1"
TGT="amd64 386 arm64"

if [ x"$KVER" = x ]; then
	echo "Usage: $0 kernel_version"
	exit 1
fi

for T in $TGT; do
	if [ ! -f files/config-$KVER-$T ]; then
		echo "Preparing config for $KVER-$T"
		KDIR=`mktemp -d -t lk-XXXXXXXXXX`
		echo "include /pkg/main/sys-kernel.linux.src.$KVER/Makefile" >"$KDIR/Makefile"

		# find best config
		BEST=""
		for foo in files/config-*-$T; do
			if [ -f $foo ]; then
				BEST="$foo"
			fi
		done
		if [ x"$BEST" = x ]; then
			# no cpu specific config, try again without specific
			for foo in files/config-*; do
				if [ `echo "$foo" | grep -c 'config-[0-9.]*$'` -gt 0 ]; then
					BEST="$foo"
				fi
			done
		fi

		if [ -f "$BEST" ]; then
			echo "Using $BEST as base config"
			cp -v "$BEST" "$KDIR/.config"
		fi

		source files/env.sh

		make -C "$KDIR" olddefconfig
		make -C "$KDIR" menuconfig
		cp -v "$KDIR/.config" "files/config-$KVER-$T"

		rm -fr "$KDIR"
	fi
done
