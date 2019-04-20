# Common stuff, variables, etc
set -e

BASEDIR=`pwd`
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

# define variables - this should work most of the time
# variable naming is based on gentoo
PF=$(basename $0 .sh)
PN=$(basename $(pwd))
CATEGORY=$(basename $(dirname $(pwd)))
# TODO fix P to not include revision if any
P=${PF}
PV=$(echo ${P} | cut -d- -f2-)
PVR=$(echo ${PF} | cut -d- -f2-)
PKG="${CATEGORY}.${PN}"
FILESDIR="${BASEDIR}/files"

CHPATH=/tmp/build/${PKG}/${PVR}/work
D=/tmp/build/${PKG}/${PVR}/dist
TPKGOUT=/tmp/tpkg

mkdir -p "${CHPATH}" "${TPKGOUT}" "${D}"
cd ${CHPATH}

get() {
	BN=`basename $1`
	if [ -f "$BN" ]; then
		return
	fi

	# try to get from our system
	wget https://pkg.tardigradeos.com/src/main/${CATEGORY}/${PN}/${BN} || true
	if [ -f "$BN" ]; then
		return
	fi

	# failed download, get file, then upload...
	wget "$1"

	aws s3 cp "$BN" s3://tpkg/src/main/${PKG/.//}/${BN}
}

squash() {
	FN=`basename $1`
	mksquashfs "$1" "${TPKGOUT}/${FN}.${OS}.${ARCH}.squashfs" -all-root -nopad -noappend
}

finalize() {
	cd "${D}"

	# fix common issues
	if [ -d "pkg/main/${PKG}.libs.${PVR}/lib/pkgconfig" ]; then
		mkdir -p "pkg/main/${PKG}.dev.${PVR}"
		mv "pkg/main/${PKG}.libs.${PVR}/lib/pkgconfig" "pkg/main/${PKG}.dev.${PVR}"
	fi
	if [ -d "pkg/main/${PKG}.core.${PVR}/info" ]; then
		mkdir -p "pkg/main/${PKG}.doc.${PVR}"
		mv "pkg/main/${PKG}.core.${PVR}/info" "pkg/main/${PKG}.doc.${PVR}"
	fi

	echo "Building squashfs..."

	for foo in pkg/main/${PKG}.*; do
		squash "$foo"
	done

	if [ x"$HSM" != x ]; then
		tpkg-convert $TPKGOUT/*.squashfs
	fi
}

cleanup() {
	echo "Cleaning up..."
	rm -fr "/tmp/build/${PKG}/${PVR}"
}
