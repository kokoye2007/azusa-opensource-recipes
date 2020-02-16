# setup env for build

case $GOARCH in
	amd64)
		export ARCH="x86_64"
		export CROSS_COMPILE=""
		;;
	386)
		export ARCH="x86"
		export CROSS_COMPILE=""
		;;
	arm64)
		export ARCH="arm64"
		export CROSS_COMPILE="aarch64-unknown-linux-gnu-"
		;;
	*)
		echo "unsupported GOARCH=$GOARCH"
		exit 1
		;;
esac
