#!/bin/sh

KVER="$1"
TGT="amd64 386 arm64"

if [ x"$KVER" = x ]; then
	echo "Usage: $0 kernel_version"
	exit 1
fi
BVER="$2"

for GOARCH in $TGT; do
	if [ ! -f files/config-$KVER-$GOARCH ]; then
		echo "Preparing config for $KVER-$GOARCH"
		KDIR=`mktemp -d -t lk-XXXXXXXXXX`
		echo "include /pkg/main/sys-kernel.linux.src.$KVER.linux.any/Makefile" >"$KDIR/Makefile"

		# find best config
		BEST=""
		for foo in files/config-*-$GOARCH; do
			if [ -f $foo ]; then
				BEST="$foo"
			fi
		done
		if [ -f "files/config-$BVER-$GOARCH" ]; then
			BEST="$BVER"
		fi
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

		# multiple passes because sometimes options only appears after values are tweaked
		for pass in `seq 1 3`; do
			make -C "$KDIR" listnewconfig | while read foo; do
				case "${foo: -1}" in
				n)
					# yes/no stuff like DEBUG typically cannot be set to m, so this will stay as no
					echo "Attempting to set ${foo:0:-2}=m"
					(cd "$KDIR"; ./source/scripts/config -m "${foo:0:-2}" )
					;;
				y)
					# default value is "y", so safe to set to y
					echo "Setting ${foo:0:-2}=y"
					(cd "$KDIR"; ./source/scripts/config -e "${foo:0:-2}" )
					;;
				esac
			done
		done
		#make -C "$KDIR" olddefconfig
		make -C "$KDIR" defconfig
		make -C "$KDIR" menuconfig
		cp -v "$KDIR/.config" "files/config-$KVER-$GOARCH"

		rm -fr "$KDIR"
	fi
done
