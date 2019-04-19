# Common stuff, variables, etc

ARCH=`uname -m`
OS=`uname -s | tr A-Z a-z`

case $ARCH in
	i?86)
		ARCH=386
		;;
	x86_64)
		ARCH=amd64
		;;
esac


get() {
	BN=`basename $1`
	if [ ! -f "$BN" ]; then
		wget $1
	fi
}

squash() {
	FN=`basename $1`
	mksquashfs "$1" "dist/${FN}.${OS}.${ARCH}.squashfs" -all-root -nopad -noappend
}
