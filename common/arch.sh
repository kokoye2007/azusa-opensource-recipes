ARCH=`uname -m`
BITS=`getconf LONG_BIT`
OS=`uname -s | tr A-Z a-z`
MULTILIB=no

case $ARCH in
	i?86)
		ARCH=386
		LIB_SUFFIX=
		BUILD_TARGET="i386-pc-linux-gnu"
		;;
	x86_64)
		if [ $BITS -eq 32 ]; then
			# actually in 32bits mode
			ARCH=386
			LIB_SUFFIX=
			BUILD_TARGET="i386-pc-linux-gnu"
		else
			ARCH=amd64
			MULTILIB=yes
			LIB_SUFFIX=64
			BUILD_TARGET="x86_64-pc-linux-gnu"
		fi
		;;
	aarch64)
		ARCH=arm64
		LIB_SUFFIX=
		BUILD_TARGET="aarch64-unknown-linux-gnu"
		;;
esac

# armv7-unknown-linux-gnueabi
