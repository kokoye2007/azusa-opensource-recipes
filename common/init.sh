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
TPKGOUT=/tmp/tpkg

mkdir -p "${CHPATH}" "${TPKGOUT}"
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
	# fix common issues
	if [ -d "dist/pkg/main/${PKG}.libs.${PVR}/lib/pkgconfig" ]; then
		mkdir -p "dist/pkg/main/${PKG}.dev.${PVR}"
		mv "dist/pkg/main/${PKG}.libs.${PVR}/lib/pkgconfig" "dist/pkg/main/${PKG}.dev.${PVR}"
	fi
	if [ -d "dist/pkg/main/${PKG}.core.${PVR}/info" ]; then
		mkdir -p "dist/pkg/main/${PKG}.doc.${PVR}"
		mv "dist/pkg/main/${PKG}.core.${PVR}/info" "dist/pkg/main/${PKG}.doc.${PVR}"
	fi

	echo "Building squashfs..."

	for foo in dist/pkg/main/${PKG}.*; do
		squash "$foo"
	done

	if [ x"$HSM" != x ]; then
		tpkg-convert $TPKGOUT/*.squashfs
	fi
}
