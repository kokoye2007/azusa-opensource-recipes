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
	if [ -f "$BN" ]; then
		return
	fi

	# try to get from our system
	wget https://pkg.tardigradeos.com/src/main/${PKG/.//}/${BN} || true
	if [ -f "$BN" ]; then
		return
	fi

	# failed download, get file, then upload...
	wget "$1"

	aws s3 cp "$BN" s3://tpkg/src/main/${PKG/.//}/${BN}
}

squash() {
	FN=`basename $1`
	mksquashfs "$1" "dist/${FN}.${OS}.${ARCH}.squashfs" -all-root -nopad -noappend
}
