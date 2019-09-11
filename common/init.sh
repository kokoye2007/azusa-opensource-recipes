# Common stuff, variables, etc
set -e

BASEDIR=`pwd`
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
esac

# define variables - this should work most of the time
# variable naming is based on gentoo
PF=$(basename $0 .sh)
PN=$(basename $(pwd))
CATEGORY=$(basename $(dirname $(pwd)))
# TODO fix P to not include revision if any
P=${PF}
PVR=${P#"${PN}-"}
PV=${P#"${PN}-"}
PKG="${CATEGORY}.${PN}"
FILESDIR="${BASEDIR}/files"

TMPBASE="$HOME/tmp/build"
CHPATH="${TMPBASE}/${PKG}/${PVR}/work"
D="${TMPBASE}/${PKG}/${PVR}/dist"
T="${TMPBASE}/${PKG}/${PVR}/temp"
APKGOUT=/tmp/apkg

if [ -d "${TMPBASE}/${PKG}/${PVR}" ]; then
	# cleanup
	rm -fr "${TMPBASE}/${PKG}/${PVR}"
fi
mkdir -p "${CHPATH}" "${D}" "${T}"
cd ${CHPATH}

extract() {
	echo "Extracting $1 ..."
	tar xf $1
}

get() {
	if [ "x$2" = x"" ]; then
		BN=`basename $1`
	else
		BN="$2"
	fi

	if [ -s "$BN" ]; then
		extract "$BN"
		return
	fi

	# try to get from our system
	wget -O "$BN" https://pkg.azusa.jp/src/main/${CATEGORY}/${PN}/${BN} || true
	if [ -s "$BN" ]; then
		extract "$BN"
		return
	fi

	# failed download, get file, then upload...
	wget -O "$BN" "$1"

	aws s3 cp "$BN" s3://azusa-pkg/src/main/${PKG/.//}/${BN}

	extract "$BN"
}

squash() {
	FN=`basename $1`
	mkdir -p "${APKGOUT}"

	if [ `id -u` -eq 0 ]; then
		# running as root, so we don't need -all-root
		mksquashfs "$1" "${APKGOUT}/${FN}.${OS}.${ARCH}.squashfs" -nopad -noappend
	else
		mksquashfs "$1" "${APKGOUT}/${FN}.${OS}.${ARCH}.squashfs" -all-root -nopad -noappend
	fi
}

finalize() {
	cd "${D}"

	LIBS=lib
	LIB=lib
	if [ $MULTILIB = yes ]; then
		LIBS="lib64 lib32"
		LIB=lib64
	fi

	# ensure lib dirs are in libs
	for foo in lib lib32 lib64; do
		if [ -d "pkg/main/${PKG}.core.${PVR}/$foo" ] && [ ! -d "pkg/main/${PKG}.libs.${PVR}/$foo" ]; then
			mkdir -p "pkg/main/${PKG}.libs.${PVR}"
			mv "pkg/main/${PKG}.core.${PVR}/$foo" "pkg/main/${PKG}.libs.${PVR}"
			ln -s "/pkg/main/${PKG}.libs.${PVR}/$foo" "pkg/main/${PKG}.core.${PVR}/$foo"
		fi
	done

	# fix common issues
	if [ $MULTILIB = yes ]; then
		for foo in core libs dev; do
			if [ -d "pkg/main/${PKG}.$foo.${PVR}/lib" -a ! -L "pkg/main/${PKG}.$foo.${PVR}/lib" ]; then
				if [ -d "pkg/main/${PKG}.$foo.${PVR}/$LIB" ]; then
					mv "pkg/main/${PKG}.$foo.${PVR}/lib"/* "pkg/main/${PKG}.$foo.${PVR}/$LIB/"
					rmdir "pkg/main/${PKG}.$foo.${PVR}/lib"
				else
					mv "pkg/main/${PKG}.$foo.${PVR}/lib" "pkg/main/${PKG}.$foo.${PVR}/$LIB"
				fi
				if [ -d "pkg/main/${PKG}.$foo.${PVR}/$LIB" -a ! -d "pkg/main/${PKG}.$foo.${PVR}/lib" ]; then
					# create a symlink lib→lib64 (or whatever)
					#rm "pkg/main/${PKG}.$foo.${PVR}/lib"
					ln -s "$LIB" "pkg/main/${PKG}.$foo.${PVR}/lib"
				fi
				#if [ -d "pkg/main/${PKG}.core.${PVR}" ]; then
					#ln -s "$LIB" "pkg/main/${PKG}.core.${PVR}/lib"
				#fi
			fi
		done
	fi

	if [ -d "pkg/main/${PKG}.libs.${PVR}/$LIB/pkgconfig" ]; then
		# pkgconfig should be in dev
		mkdir -p "pkg/main/${PKG}.dev.${PVR}/$LIB"
		mv "pkg/main/${PKG}.libs.${PVR}/$LIB/pkgconfig" "pkg/main/${PKG}.dev.${PVR}"
		ln -s "/pkg/main/${PKG}.dev.${PVR}/pkgconfig" "pkg/main/${PKG}.libs.${PVR}/$LIB"
	fi

	if [ -d "pkg/main/${PKG}.core.${PVR}/include" ]; then
		mkdir -p "pkg/main/${PKG}.dev.${PVR}"
		mv "pkg/main/${PKG}.core.${PVR}/include" "pkg/main/${PKG}.dev.${PVR}/include"
		ln -s "/pkg/main/${PKG}.dev.${PVR}/include" "pkg/main/${PKG}.core.${PVR}/include"
	fi

	for foo in $LIBS; do
		if [ -d "pkg/main/${PKG}.libs.${PVR}/$foo" ]; then
			# check for any .a file, move to dev
			mkdir -p "pkg/main/${PKG}.dev.${PVR}/$foo"
			if [ $foo = lib64 ]; then
				ln -s lib64 "pkg/main/${PKG}.dev.${PVR}/lib"
			fi
			count=`find "pkg/main/${PKG}.libs.${PVR}/$foo" -name '*.a' | wc -l`
			if [ $count -gt 0 ]; then
				mv "pkg/main/${PKG}.libs.${PVR}/$foo"/*.a "pkg/main/${PKG}.dev.${PVR}/$foo"
			fi
			# link whatever remains to dev
			for bar in "pkg/main/${PKG}.libs.${PVR}/$foo"/*; do
				ln -s "/$bar" "pkg/main/${PKG}.dev.${PVR}/$foo"
			done
		fi
	done

	for foo in man info share/man share/info; do
		if [ -d "pkg/main/${PKG}.core.${PVR}/$foo" ]; then
			# this should be in doc
			mkdir -p "pkg/main/${PKG}.doc.${PVR}"
			mv "pkg/main/${PKG}.core.${PVR}/$foo" "pkg/main/${PKG}.doc.${PVR}"
			rmdir "pkg/main/${PKG}.core.${PVR}/$foo" || true
			rmdir "pkg/main/${PKG}.core.${PVR}" || true
		fi
	done

	archive
}

archive() {
	echo "Building squashfs..."

	for foo in pkg/main/${PKG}.*; do
		squash "$foo"
	done

	if [ x"$HSM" != x ]; then
		apkg-convert $APKGOUT/*.squashfs
	fi
}

cleanup() {
	echo "Cleaning up..."
	rm -fr "${TMPBASE}/${PKG}/${PVR}"
}

callconf() {
	# try to locate configure
	if [ -x ./configure ]; then
		./configure "$@"
		return
	fi
	if [ -x ${CHPATH}/${P}/configure ]; then
		${CHPATH}/${P}/configure "$@"
		return
	fi

	CONFPATH=`echo "${CHPATH}"/*/configure`
	if [ -x "$CONFPATH" ]; then
		"${CONFPATH}" "$@"
		return
	fi

	echo "doconf: Could not locate configure"
	exit 1
}

doconf() {
	echo "Running configure..."
	callconf --prefix=/pkg/main/${PKG}.core.${PVR} --sysconfdir=/etc \
	--includedir=/pkg/main/${PKG}.dev.${PVR}/include --libdir=/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX --datarootdir=/pkg/main/${PKG}.core.${PVR}/share \
	--mandir=/pkg/main/${PKG}.doc.${PVR}/man --docdir=/pkg/main/${PKG}.doc.${PVR}/doc "$@"
}
