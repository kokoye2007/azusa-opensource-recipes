# Common stuff, variables, etc
set -e

BASEDIR=`pwd`
if [ x"$ROOTDIR" = x ]; then
	ROOTDIR=$(realpath $BASEDIR/../..)
fi
source "$ROOTDIR/common/arch.sh"

# define variables - this should work most of the time
# variable naming is based on gentoo
PF=$(basename $0 .sh)
PN=$(basename $(pwd))
CATEGORY=$(basename $(dirname $(pwd)))
# TODO fix P to not include revision if any
P=${PF}
PVR="${P#"${PN}-"}.${OS}.${ARCH}"
PV=${P#"${PN}-"}
PKG="${CATEGORY}.${PN}"
FILESDIR="${BASEDIR}/files"

# make pkg-config use our libs
export PKG_CONFIG_LIBDIR=/pkg/main/azusa.symlinks.core/pkgconfig
export XDG_DATA_DIRS="/usr/share"

if [ -w /build/ ]; then
	TMPBASE="/build"
else
	TMPBASE="$HOME/tmp/build"
fi
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

inherit() {
	for foo in "$@"; do
		source ${ROOTDIR}/common/$foo.sh
	done
}

extract() {
	echo "Extracting $1 ..."
	case $1 in
		*.zip)
			unzip -q $1
			;;
		*.tar.*|*.tgz|*.tbz2)
			tar xf $1
			;;
		*.gz)
			gunzip $1
			;;
	esac
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
	wget --ca-certificate=/etc/ssl/certs/ca-certificates.crt -O "$BN" `echo "https://pkg.azusa.jp/src/main/${CATEGORY}/${PN}/${BN}" | sed -e 's/+/%2B/g'` || true
	if [ -s "$BN" ]; then
		extract "$BN"
		return
	fi

	# failed download, get file, then upload...
	wget -O "$BN" "$1"

	aws s3 cp "$BN" s3://azusa-pkg/src/main/${PKG/.//}/${BN}

	extract "$BN"
}

prepare() {
	echo "Checking for config.sub / config.guess"
	find "${CHPATH}" -name config.sub -o -name config.guess | while read foo; do
		rm -fv "$foo"
		ln -snfTv /pkg/main/sys-devel.gnuconfig.core/share/gnuconfig/`basename "$foo"` "$foo"
	done
}

squash() {
	FN=`basename $1`
	mkdir -p "${APKGOUT}"
	# check fn: 
	if [ `echo "$FN" | grep -c -E '\.(linux)\.(amd64|386|arm|arm64)$'` -eq 0 ]; then
		# add
		FN="${FN}.${OS}.${ARCH}"
	fi

	if [ `id -u` -eq 0 ]; then
		# running as root, so we don't need -all-root
		mksquashfs "$1" "${APKGOUT}/${FN}.squashfs" -nopad -noappend
	else
		mksquashfs "$1" "${APKGOUT}/${FN}.squashfs" -all-root -nopad -noappend
	fi
}

get_target() {
	# $1 is one of "core", "libs", etc
	echo "${PKG}.$1.${PVR}"
}

organize() {
	cd "${D}"

	LIBS=lib
	LIB=lib
	if [ $MULTILIB = yes ]; then
		LIBS="lib64 lib32"
		LIB=lib64
	fi

	# remove any .la file
	# see: https://wiki.gentoo.org/wiki/Project:Quality_Assurance/Handling_Libtool_Archives
	find "${D}" -name '*.la' -delete

	# ensure lib dirs are in libs and not core
	for foo in lib lib32 lib64; do
		if [ -d "pkg/main/${PKG}.core.${PVR}/$foo" -a ! -L "pkg/main/${PKG}.core.${PVR}/$foo" ]; then
			echo "Moving core $foo directory to libs"
			mkdir -p "pkg/main/${PKG}.libs.${PVR}/$foo"
			mv -v "pkg/main/${PKG}.core.${PVR}/$foo"/* "pkg/main/${PKG}.libs.${PVR}/$foo" || true
			rm -frv "pkg/main/${PKG}.core.${PVR}/$foo"
			ln -sv "/pkg/main/${PKG}.libs.${PVR}/$foo" "pkg/main/${PKG}.core.${PVR}/$foo"
		fi
	done

	# fix common issues
	if [ $MULTILIB = yes ]; then
		for foo in core libs dev; do
			# if we have a "lib" dir and no lib64, move it
			if [ -d "pkg/main/${PKG}.$foo.${PVR}/lib" -a ! -d "pkg/main/${PKG}.$foo.${PVR}/$LIB" ]; then
				mv -v "pkg/main/${PKG}.$foo.${PVR}/lib" "pkg/main/${PKG}.$foo.${PVR}/$LIB"
				ln -snfv "$LIB" "pkg/main/${PKG}.$foo.${PVR}/lib"
				continue
			fi
			# ensure we have a "lib" symlink to lib64 if it exists
			if [ -d "pkg/main/${PKG}.$foo.${PVR}/$LIB" -a ! -d "pkg/main/${PKG}.$foo.${PVR}/lib" ]; then
				ln -snfv "$LIB" "pkg/main/${PKG}.$foo.${PVR}/lib"
			fi
		done
	fi

	if [ -d "${D}/etc" ]; then
		# move it to core
		mkdir -p "${D}/pkg/main/${PKG}.core.${PVR}"
		mv -Tv etc "${D}/pkg/main/${PKG}.core.${PVR}/etc"
	fi

	for foo in pkgconfig cmake; do
		if [ -d "pkg/main/${PKG}.libs.${PVR}/$LIB/$foo" ]; then
			# should be in dev
			mkdir -pv "pkg/main/${PKG}.dev.${PVR}"
			mv -v "pkg/main/${PKG}.libs.${PVR}/$LIB/$foo" "pkg/main/${PKG}.dev.${PVR}"
			ln -sv "/pkg/main/${PKG}.dev.${PVR}/$foo" "pkg/main/${PKG}.libs.${PVR}/$LIB"
		elif [ -d "pkg/main/${PKG}.core.${PVR}/share/$foo" ]; then
			# should be in dev
			mkdir -pv "pkg/main/${PKG}.dev.${PVR}"
			mv -v "pkg/main/${PKG}.core.${PVR}/share/$foo" "pkg/main/${PKG}.dev.${PVR}"
			ln -sv "/pkg/main/${PKG}.dev.${PVR}/$foo" "pkg/main/${PKG}.core.${PVR}/share"
		fi
	done

	if [ -d "pkg/main/${PKG}.core.${PVR}/include" ]; then
		mkdir -pv "pkg/main/${PKG}.dev.${PVR}"
		mv -v "pkg/main/${PKG}.core.${PVR}/include" "pkg/main/${PKG}.dev.${PVR}/include"
		ln -sv "/pkg/main/${PKG}.dev.${PVR}/include" "pkg/main/${PKG}.core.${PVR}/include"
	fi

	for foo in $LIBS; do
		if [ -d "pkg/main/${PKG}.libs.${PVR}/$foo" ]; then
			# check for any .a file, move to dev
			mkdir -pv "pkg/main/${PKG}.dev.${PVR}/$foo"
			if [ $foo = lib64 ]; then
				ln -sv lib64 "pkg/main/${PKG}.dev.${PVR}/lib"
			fi
			count=`find "pkg/main/${PKG}.libs.${PVR}/$foo" -maxdepth 0 -name '*.a' | wc -l`
			if [ $count -gt 0 ]; then
				mv -v "pkg/main/${PKG}.libs.${PVR}/$foo"/*.a "pkg/main/${PKG}.dev.${PVR}/$foo"
			fi
			# link whatever remains to dev
			for bar in "pkg/main/${PKG}.libs.${PVR}/$foo"/*; do
				ln -snfv "/$bar" "pkg/main/${PKG}.dev.${PVR}/$foo"
			done
		fi
	done

	for foo in man info share/man share/info; do
		if [ -d "pkg/main/${PKG}.core.${PVR}/$foo" ]; then
			# this should be in doc
			mkdir -pv "pkg/main/${PKG}.doc.${PVR}"
			mv -v "pkg/main/${PKG}.core.${PVR}/$foo" "pkg/main/${PKG}.doc.${PVR}"
			rmdir "pkg/main/${PKG}.core.${PVR}/$foo" || true
			rmdir "pkg/main/${PKG}.core.${PVR}" || true
		fi
	done
}

archive() {
	SUIDEXE="$(find "${D}" -user root -perm -4000 -ls)"
	if [ x"$SUIDEXE" != x ]; then
		echo "WARNING PACKAGE CONTAINS SUID FILES:"
		echo "$SUIDEXE"
		echo
		sleep 5
	fi

	if [ -f "${BASEDIR}/azusa.yaml" ]; then
		if [ -d "${D}/pkg/main/${PKG}.core.${PVR}" ]; then
			cp -vT "${BASEDIR}/azusa.yaml" "${D}/pkg/main/${PKG}.core.${PVR}/azusa.yaml"
		fi
	fi

	echo "Building squashfs..."
	cd "${D}"

	for foo in pkg/main/${PKG}.*; do
		squash "$foo"
	done

	if [ x"$HSM" != x ]; then
		apkg-convert $APKGOUT/*.squashfs
	fi
}

finalize() {
	organize
	archive
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

	if [ x"$CONFPATH" != x ]; then
		"${CONFPATH}" "$@"
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
	callconf --prefix=/pkg/main/${PKG}.core.${PVR} --sysconfdir=/etc --localstatedir=/var \
	--includedir=/pkg/main/${PKG}.dev.${PVR}/include --libdir=/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX --datarootdir=/pkg/main/${PKG}.core.${PVR}/share \
	--mandir=/pkg/main/${PKG}.doc.${PVR}/man --docdir=/pkg/main/${PKG}.doc.${PVR}/doc "$@"
}

doconflight() {
	echo "Running configure..."
	callconf --prefix=/pkg/main/${PKG}.core.${PVR} "$@"
}

doconf213() {
	echo "Running configure..."
	callconf --prefix=/pkg/main/${PKG}.core.${PVR} --sysconfdir=/etc \
	--includedir=/pkg/main/${PKG}.dev.${PVR}/include --libdir=/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX --datarootdir=/pkg/main/${PKG}.core.${PVR}/share \
	--mandir=/pkg/main/${PKG}.doc.${PVR}/man "$@"
}

cmakeenv() {
	# export a bunch of package ENV vars so cmake is easier to use
	export LibRHash_ROOT=/pkg/main/app-crypt.rhash.dev ZLIB_ROOT=/pkg/main/sys-libs.zlib.dev LibArchive_ROOT=/pkg/main/app-arch.libarchive.dev JsonCpp_ROOT=/pkg/main/dev-libs.jsoncpp.dev LibUV_ROOT=/pkg/main/dev-libs.libuv.dev
	export X11_ROOT=/pkg/main/x11-libs.libX11.dev ALSA_ROOT=/pkg/main/media-libs.alsa-lib.dev XKBFile_ROOT=/pkg/main/x11-libs.libxkbfile.dev XShm_ROOT=/pkg/main/x11-libs.libXext.dev Xinerama_ROOT=/pkg/main/x11-libs.libXinerama.dev
	export Xext_ROOT=/pkg/main/x11-libs.libXext.dev Xcursor_ROOT=/pkg/main/x11-libs.libXcursor.dev Xv_ROOT=/pkg/main/x11-libs.libXv.dev Xi_ROOT=/pkg/main/x11-libs.libXi.dev Xrender_ROOT=/pkg/main/x11-libs.libXrender.dev
	export XRandR_ROOT=/pkg/main/x11-libs.libXrandr.dev Xfixes_ROOT=/pkg/main/x11-libs.libXfixes.dev Freetype_ROOT=/pkg/main/media-libs.freetype.dev
	export JPEG_ROOT=/pkg/main/media-libs.libjpeg-turbo.dev PNG_ROOT=/pkg/main/media-libs.libpng.dev TIFF_ROOT=/pkg/main/media-libs.tiff.dev OpenJPEG_ROOT=/pkg/main/media-libs.openjpeg.dev
	export Boost_ROOT=/pkg/main/dev-libs.boost.dev
}

docmake() {
	echo "Running cmake..."
	if [ x"$CMAKE_ROOT" = x ]; then
		CMAKE_ROOT="${CHPATH}/${P}"
	fi

	cmakeenv

	cmake "$CMAKE_ROOT" -DCMAKE_INSTALL_PREFIX="/pkg/main/${PKG}.core.${PVR}" -DCMAKE_BUILD_TYPE=Release "$@"
}

importcmakepkg() {
	local PKGNAME="$1"
	local PKGVARNAME="$2"

	if [ x"$PKGVARNAME" = x ]; then
		PKGVARNAME="$(echo "${PKGNAME#*/}" | tr a-z A-Z)"
	fi

	eval "export ${PKGVARNAME}_ROOT=/pkg/main/${PKGNAME/\//.}.dev"
}

importpkg() {
	local PKGCFG=""
	for foo in "$@"; do
		if [[ $foo == */* ]]; then
			# standard import paths
			export CPPFLAGS="$CPPFLAGS -I/pkg/main/${foo/\//.}.dev/include"
			export LDFLAGS="$LDFLAGS -L/pkg/main/${foo/\//.}.libs/lib$LIB_SUFFIX"
		else
			PKGCFG="$PKGCFG $foo"
		fi
	done

	if [ x"$PKGCFG" != x ]; then
		pkg-config --exists --print-errors "$PKGCFG"
		export CPPFLAGS="$CPPFLAGS $(pkg-config --cflags-only-I "$PKGCFG")"
		export LDFLAGS="$LDFLAGS $(pkg-config --libs-only-L "$PKGCFG")"
	fi
}

# azusa check
acheck() {
	# check if env is sane for building, and perform stuff
	if [ ! -d /.pkg-main-rw ]; then
		echo "This needs to be built in Azusa Build env:"
		echo "$ROOTDIR/common/build.sh ${CATEGORY}/${PN}/${PF}.sh"
		exit
	fi

	# TODO check if /.pkg-main-rw is indeed empty, etc
}

# apply patches
apatch() {
	for foo in "$@"; do
		if [ ! -f "$foo" ]; then
			echo "Missing patch file: $foo"
			exit 1
		fi
		echo " * Applying patch $foo"
		for dp in 1 0 2; do
			patch -p"$dp" -Nt -i "$foo" && continue 2 || true
		done
		# failed to apply patch
		echo "Failed to apply patch"
		exit 1
	done
}

aautoreconf() {
	echo "Running autoreconf tools..."
	libtoolize --force --install
	autoreconf -fi -I /pkg/main/azusa.symlinks.core/share/aclocal/
}
