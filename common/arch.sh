ARCH=`uname -m`
OS=`uname -s | tr A-Z a-z`
MULTILIB=no

case $ARCH in
	i?86)
		ARCH=386
		LIB_SUFFIX=
		;;
	x86_64)
		ARCH=amd64
		MULTILIB=yes
		LIB_SUFFIX=64
		;;
	aarch64)
		ARCH=arm64
		LIB_SUFFIX=
		;;
esac
