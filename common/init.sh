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
if [ x"$NPROC" = x ]; then
	NPROC=`nproc 2>/dev/null || echo 1`
fi

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

detect_src() {
	if [ x"$S" = x ]; then
		local foo
		for foo in */; do
			if [ -d "$foo" ]; then
				S="${PWD}/${foo%/}"
				break
			fi
		done
	fi
}

extract() {
	echo "Extracting $1 ..."
	case $1 in
		*.zip)
			unzip -q $1
			detect_src
			;;
		*.tar.*|*.tgz|*.tbz2)
			tar xf $1
			detect_src
			;;
		*.gz)
			gunzip $1
			detect_src
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

	if [ -f "$HOME/.aws/credentials" ]; then
		# upload if possible to aws
		aws s3 cp "$BN" s3://azusa-pkg/src/main/${PKG/.//}/${BN}
	fi

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
			fi
			if [ -d "pkg/main/${PKG}.$foo.${PVR}/lib" -a ! -L "pkg/main/${PKG}.$foo.${PVR}/lib"  -a -d "pkg/main/${PKG}.$foo.${PVR}/$LIB" ]; then
				# move stuff
				mv -v "pkg/main/${PKG}.$foo.${PVR}/lib"/* "pkg/main/${PKG}.$foo.${PVR}/$LIB"
				rmdir "pkg/main/${PKG}.$foo.${PVR}/lib"
			fi
			# ensure we have a "lib" symlink to lib64 if it exists
			if [ -d "pkg/main/${PKG}.$foo.${PVR}/$LIB" -a ! -d "pkg/main/${PKG}.$foo.${PVR}/lib" ]; then
				ln -snfv "$LIB" "pkg/main/${PKG}.$foo.${PVR}/lib"
			fi
		done
	fi

	if [ -d "${D}/etc" ]; then
		# move it to core
		if [ -d "${D}/pkg/main/${PKG}.core.${PVR}/etc" ]; then
			# already ahve etc, try to merge
			mv -v "${D}/etc"/* "${D}/pkg/main/${PKG}.core.${PVR}/etc"
			rmdir "${D}/etc"
		else
			mkdir -p "${D}/pkg/main/${PKG}.core.${PVR}"
			mv -Tv "${D}/etc" "${D}/pkg/main/${PKG}.core.${PVR}/etc"
		fi
	fi

	if [ -d "${D}/lib/udev" ]; then
		# we got udev rules/etc, move these to core
		mkdir -p "${D}/pkg/main/${PKG}.core.${PVR}"
		mv -Tv "${D}/lib/udev" "${D}/pkg/main/${PKG}.core.${PVR}/udev"
	fi

	if [ "$PN" != "font-util" ]; then
		if [ -d "${D}/pkg/main/media-fonts.font-util.core".*/share/fonts ]; then
			# looks like fonts were installed in the wrong place.
			mkdir -p "${D}/pkg/main/${PKG}.fonts.${PVR}"
			mv -v "${D}/pkg/main/media-fonts.font-util.core".*/share/fonts/* "${D}/pkg/main/${PKG}.fonts.${PVR}"
		fi
	fi

	for foo in pkgconfig cmake; do
		if [ -d "pkg/main/${PKG}.libs.${PVR}/$LIB/$foo" ]; then
			# should be in dev
			mkdir -pv "pkg/main/${PKG}.dev.${PVR}"
			mv -v "pkg/main/${PKG}.libs.${PVR}/$LIB/$foo" "pkg/main/${PKG}.dev.${PVR}"
			ln -sv "/pkg/main/${PKG}.dev.${PVR}/$foo" "pkg/main/${PKG}.libs.${PVR}/$LIB"
		fi
		if [ -d "pkg/main/${PKG}.core.${PVR}/share/$foo" ]; then
			# should be in dev
			mkdir -pv "pkg/main/${PKG}.dev.${PVR}"
			if [ ! -d "pkg/main/${PKG}.core.${PVR}/share/$foo" ]; then
				mv -v "pkg/main/${PKG}.core.${PVR}/share/$foo" "pkg/main/${PKG}.dev.${PVR}"
			else
				mv -v "pkg/main/${PKG}.core.${PVR}/share/$foo"/* "pkg/main/${PKG}.dev.${PVR}/$foo"
				rmdir -v "pkg/main/${PKG}.core.${PVR}/share/$foo"
			fi
			ln -sv "/pkg/main/${PKG}.dev.${PVR}/$foo" "pkg/main/${PKG}.core.${PVR}/share"
		fi
	done
	if [ -d "pkg/main/${PKG}.libs.${PVR}/$LIB/udev" ]; then
		# should be in core
		mkdir -pv "pkg/main/${PKG}.core.${PVR}"
		mv -v "pkg/main/${PKG}.libs.${PVR}/$LIB/udev" "pkg/main/${PKG}.core.${PVR}/"
		ln -sv "/pkg/main/${PKG}.core.${PVR}/udev" "pkg/main/${PKG}.libs.${PVR}/$LIB"
	fi

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

	for foo in "pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX"/python*/; do
		if [ -d "$foo" ]; then
			# this should be in a python module dir, not here. Let's try to find out what version of python this is and move it around.
			PYTHON=`basename "$foo"` # for example "python3.8"
			VER=`"$PYTHON" --version | awk '{ print $2 }'` # 3.8.6 or whatever
			mkdir -pv "pkg/main/${PKG}.mod.${PVR}.py${VER}/lib"
			mv -v "$foo" "pkg/main/${PKG}.mod.${PVR}.py${VER}/lib"
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
	if [ x"$CONFPATH" != x ]; then
		"${CONFPATH}" "$@"
		return
	fi

	if [ -x ./configure ]; then
		./configure "$@"
		return
	fi
	if [ -x "${S}/configure" ]; then
		"${S}/configure" "$@"
		return
	fi
	if [ -x "${CHPATH}/configure" ]; then
		"${CHPATH}/configure" "$@"
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

domeson() {
	inherit meson
	domeson "$@" || return $?
}

docmake() {
	inherit cmake
	docmake "$@" || return $?
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
			if [ -d "/pkg/main/${foo/\//.}.dev/include" ]; then
				export CPPFLAGS="$CPPFLAGS -I/pkg/main/${foo/\//.}.dev/include"
				CMAKE_INCLUDE_PATH="${CMAKE_INCLUDE_PATH};/pkg/main/${foo/\//.}.dev/include"
			fi
			if [ -d "/pkg/main/${foo/\//.}.libs/lib$LIB_SUFFIX" ]; then
				export LDFLAGS="$LDFLAGS -L/pkg/main/${foo/\//.}.libs/lib$LIB_SUFFIX"
				CMAKE_LIBRARY_PATH="${CMAKE_LIBRARY_PATH};/pkg/main/${foo/\//.}.dev/include"
			fi
		elif [ "$foo" = "X" ]; then
			# import all of X11
			local sub=("x11-base/xorg-proto")
			for foo in "${ROOTDIR}/x11-libs"/lib*; do
				lib=`basename "$foo"`
				sub+=("x11-libs/$lib")
			done
			importpkg "${sub[@]}"
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

	# disable networking
	# TODO we should actually disable the whole net stack in local container
	echo -n >/etc/resolv.conf

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
	local EXTRAOPT=()
	if [ -d "$S/m4" ]; then
		EXTRAOPT+=(-I "$S/m4")
	fi
	libtoolize --force --install
	autoreconf -fi -I /pkg/main/azusa.symlinks.core/share/aclocal/ "${EXTRAOPT[@]}"
}
