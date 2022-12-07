#!/bin/bash
# Common stuff, variables, etc
set -e

BASEDIR="$(pwd)"
if [ x"$ROOTDIR" = x ]; then
	ROOTDIR=$(realpath "$BASEDIR/../..")
fi
source "$ROOTDIR/common/arch.sh"

# define variables - this should work most of the time
# variable naming is based on gentoo
PF=$(basename "$0" .sh)
PN=$(basename "$(pwd)")
CATEGORY=$(basename "$(dirname "$(pwd)")")
# TODO fix P to not include revision if any
PR="${PF}"
P="$(echo "$PR" | sed -r -e 's/-r[0-9]+$//')"
PVR="${PR#"${PN}-"}"
PVRF="${PVR}.${OS}.${ARCH}"
PV="${P#"${PN}-"}"
PVF="${PV}.${OS}.${ARCH}"
PKG="${CATEGORY}.${PN}"
FILESDIR="${BASEDIR}/files"
if [ x"$NPROC" = x ]; then
	NPROC="$(nproc 2>/dev/null || echo 1)"
fi

# make pkg-config use our libs
export PKG_CONFIG_LIBDIR=/pkg/main/azusa.symlinks.core.${OS}.${ARCH}/pkgconfig
export XDG_DATA_DIRS="/usr/share"

if [ -w /build/ ]; then
	TMPBASE="/build"
else
	TMPBASE="$HOME/tmp/build"
fi
PKGBASE="${TMPBASE}/${PN}-${PVR}"
WORKDIR="${PKGBASE}/work"
CHPATH="$WORKDIR" ## COMPAT XXX REMOVEME
D="${PKGBASE}/dist"
T="${PKGBASE}/temp"
APKGOUT=/tmp/apkg
export CPPFLAGS="-pipe -Wall"

if [ -d "${PKGBASE}" ]; then
	# cleanup
	rm -fr "${PKGBASE}"
fi
mkdir -p "${CHPATH}" "${D}" "${T}"
cd "${CHPATH}"

inherit() {
	for foo in "$@"; do
		source "${ROOTDIR}/common/$foo.sh"
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
			unzip -q "$1"
			detect_src
			;;
		*.tar.*|*.tgz|*.tbz2)
			tar xf "$1"
			detect_src
			;;
		*.gz)
			gunzip "$1"
			;;
		*.xz)
			xz -d "$1"
			;;
	esac
}

get() {
	if [ "x$2" = x"" ]; then
		BN=$(basename "$1")
	else
		BN="$2"
	fi

	download "$1" "$BN"
	extract "$BN"
}

apfx() {
	if [ x"$1" != x ]; then
		echo "/pkg/main/${PKG}.$1.${PVRF}"
		return
	fi
	# default to core
	echo "/pkg/main/${PKG}.core.${PVRF}"
}

dpfx() {
	echo -n "${D%/}"
	apfx "$1"
}

download() {
	if [ "x$2" = x"" ]; then
		BN=$(basename "$1")
	else
		BN="$2"
	fi

	if [ -s "$BN" ]; then
		return
	fi

	# try to get from our system
	wget --ca-certificate=/etc/ssl/certs/ca-certificates.crt -O "$BN" "$(echo "https://pkg.azusa.jp/src/main/${CATEGORY}/${PN}/${BN}" | sed -e 's/+/%2B/g')" || true
	if [ -s "$BN" ]; then
		return
	fi

	# failed download, get file, then upload...
	wget -O "$BN" "$1" || true
	if [ ! -s "$BN" ]; then
		# try gentoo mirror
		wget -O "$BN" "https://ftp.iij.ad.jp/pub/linux/gentoo/distfiles/$BN"
	fi

	if [ -f "$HOME/.aws/credentials" ]; then
		# upload if possible to aws
		aws s3 cp "$BN" "s3://azusa-pkg/src/main/${PKG/.//}/${BN}"
	fi
}

prepare() {
	echo "Checking for config.sub / config.guess"
	find "${CHPATH}" -name config.sub -o -name config.guess | while read -r foo; do
		rm -fv "$foo"
		ln -snfTv "/pkg/main/sys-devel.gnuconfig.core/share/gnuconfig/$(basename "$foo")" "$foo"
	done
}

squash() {
	FN=$(basename "$1")
	mkdir -p "${APKGOUT}"
	# check fn: 
	if [ "$(echo "$FN" | grep -c -E '\.(linux)\.(amd64|386|arm|arm64|any)$')" -eq 0 ]; then
		# add
		FN="${FN}.${OS}.${ARCH}"
	fi

	if [ "$(id -u)" -eq 0 ]; then
		# running as root, so we don't need -all-root
		mksquashfs "$1" "${APKGOUT}/${FN}.squashfs" -nopad -noappend
	else
		mksquashfs "$1" "${APKGOUT}/${FN}.squashfs" -all-root -nopad -noappend
	fi
}

org_movelib() {
	echo "Fixing libs..."
	# remove any .la file
	# see: https://wiki.gentoo.org/wiki/Project:Quality_Assurance/Handling_Libtool_Archives
	find "${D}" -name '*.la' -delete

	# ensure lib dirs are in libs and not core
	for foo in lib lib32 lib64; do
		if [ -d "${D}/pkg/main/${PKG}.core.${PVRF}/$foo" ] && [ ! -L "${D}/pkg/main/${PKG}.core.${PVRF}/$foo" ]; then
			echo "Moving core $foo directory to libs"
			mkdir -p "${D}/pkg/main/${PKG}.libs.${PVRF}/$foo"
			mv -v "${D}/pkg/main/${PKG}.core.${PVRF}/$foo"/* "${D}/pkg/main/${PKG}.libs.${PVRF}/$foo" || true
			rm -frv "${D}/pkg/main/${PKG}.core.${PVRF}/$foo"
			ln -sv "/pkg/main/${PKG}.libs.${PVRF}/$foo" "${D}/pkg/main/${PKG}.core.${PVRF}/$foo"
		fi
	done
}

org_fixmultilib() {
	echo "Fixing multilib files..."
	if [ "$MULTILIB" != yes ]; then
		return
	fi

	local LIB=lib64

	# fix common issues
	for foo in core libs dev; do
		# if we have a "lib" dir and no lib64, move it
		if [ -d "${D}/pkg/main/${PKG}.$foo.${PVRF}/lib" ] && [ ! -d "${D}/pkg/main/${PKG}.$foo.${PVRF}/$LIB" ]; then
			mv -v "${D}/pkg/main/${PKG}.$foo.${PVRF}/lib" "${D}/pkg/main/${PKG}.$foo.${PVRF}/$LIB"
			ln -snfv "$LIB" "${D}/pkg/main/${PKG}.$foo.${PVRF}/lib"
		fi
		if [ -d "${D}/pkg/main/${PKG}.$foo.${PVRF}/lib" ] && [ ! -L "${D}/pkg/main/${PKG}.$foo.${PVRF}/lib" ] && [ -d "${D}/pkg/main/${PKG}.$foo.${PVRF}/$LIB" ]; then
			# move stuff
			mv -v "${D}/pkg/main/${PKG}.$foo.${PVRF}/lib"/* "${D}/pkg/main/${PKG}.$foo.${PVRF}/$LIB"
			rmdir "${D}/pkg/main/${PKG}.$foo.${PVRF}/lib"
		fi
		# ensure we have a "lib" symlink to lib64 if it exists
		if [ -d "${D}/pkg/main/${PKG}.$foo.${PVRF}/$LIB" ] && [ ! -d "${D}/pkg/main/${PKG}.$foo.${PVRF}/lib" ]; then
			ln -snfv "$LIB" "${D}/pkg/main/${PKG}.$foo.${PVRF}/lib"
		fi
	done
}

org_moveetc() {
	echo "Fixing /etc directory files..."
	if [ -d "${D}/etc" ]; then
		# move it to core
		if [ -d "${D}/pkg/main/${PKG}.core.${PVRF}/etc" ]; then
			# already ahve etc, try to merge
			mv -v "${D}/etc"/* "${D}/pkg/main/${PKG}.core.${PVRF}/etc"
			rmdir "${D}/etc"
		else
			mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}"
			mv -Tv "${D}/etc" "${D}/pkg/main/${PKG}.core.${PVRF}/etc"
		fi
	fi
}

org_fixdev() {
	echo "Running fixdev (moving development files like pkgconfig and cmake)..."
	local LIB=lib
	if [ "$MULTILIB" = yes ]; then
		LIB=lib64
	fi

	# fix common issues
	for foo in pkgconfig cmake; do
		if [ -d "${D}/pkg/main/${PKG}.libs.${PVRF}/$LIB/$foo" ]; then
			# should be in dev
			if [ -d "${D}/pkg/main/${PKG}.dev.${PVRF}/$foo" ]; then
				# already found in destination, only move contents
				mv -v "${D}/pkg/main/${PKG}.libs.${PVRF}/$LIB/$foo"/* "${D}/pkg/main/${PKG}.dev.${PVRF}/$foo"
			else
				mkdir -pv "${D}/pkg/main/${PKG}.dev.${PVRF}"
				mv -v "${D}/pkg/main/${PKG}.libs.${PVRF}/$LIB/$foo" "${D}/pkg/main/${PKG}.dev.${PVRF}"
			fi
			ln -sv "/pkg/main/${PKG}.dev.${PVRF}/$foo" "${D}/pkg/main/${PKG}.libs.${PVRF}/$LIB"
		fi
		if [ -d "${D}/pkg/main/${PKG}.core.${PVRF}/share/$foo" ]; then
			# should be in dev
			mkdir -pv "${D}/pkg/main/${PKG}.dev.${PVRF}"
			if [ ! -d "${D}/pkg/main/${PKG}.core.${PVRF}/share/$foo" ]; then
				mv -v "${D}/pkg/main/${PKG}.core.${PVRF}/share/$foo" "${D}/pkg/main/${PKG}.dev.${PVRF}"
			else
				mkdir -p "${D}/pkg/main/${PKG}.dev.${PVRF}/$foo"
				mv -v "${D}/pkg/main/${PKG}.core.${PVRF}/share/$foo"/* -t "${D}/pkg/main/${PKG}.dev.${PVRF}/$foo"
				rmdir -v "${D}/pkg/main/${PKG}.core.${PVRF}/share/$foo"
			fi
			ln -sv "/pkg/main/${PKG}.dev.${PVRF}/$foo" "${D}/pkg/main/${PKG}.core.${PVRF}/share"
		fi
	done

	if [ -d "${D}/pkg/main/${PKG}.core.${PVRF}/include" ]; then
		mkdir -pv "${D}/pkg/main/${PKG}.dev.${PVRF}"
		mv -v "${D}/pkg/main/${PKG}.core.${PVRF}/include" "${D}/pkg/main/${PKG}.dev.${PVRF}/include"
		ln -sv "/pkg/main/${PKG}.dev.${PVRF}/include" "${D}/pkg/main/${PKG}.core.${PVRF}/include"
	fi
}

organize() {
	cd "${D}"
	echo "Running organize ..."

	local LIBS=lib
	local LIB=lib
	if [ "$MULTILIB" = yes ]; then
		LIBS="lib64 lib32"
		LIB=lib64
	fi

	org_movelib
	org_fixmultilib
	org_moveetc
	org_fixdev

	if [ -d "${D}/lib/udev" ]; then
		echo "Moving udev rules..."
		# we got udev rules/etc, move these to core
		mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}"
		mv -Tv "${D}/lib/udev" "${D}/pkg/main/${PKG}.core.${PVRF}/udev"
	fi

	if [ "$PN" != "font-util" ]; then
		for foo in "${D}/pkg/main/media-fonts.font-util.core".*/share/fonts; do
			if [ ! -d "$foo" ]; then
				continue
			fi
			# looks like fonts were installed in the wrong place.
			mkdir -p "${D}/pkg/main/${PKG}.fonts.${PVRF}"
			mv -v "${D}/pkg/main/media-fonts.font-util.core".*/share/fonts/* "${D}/pkg/main/${PKG}.fonts.${PVRF}"
		done
	fi

	if [ -d "${D}/pkg/main/${PKG}.libs.${PVRF}/$LIB/udev" ]; then
		echo "Moving udev files to core..."
		# should be in core
		mkdir -pv "${D}/pkg/main/${PKG}.core.${PVRF}"
		mv -v "${D}/pkg/main/${PKG}.libs.${PVRF}/$LIB/udev" "${D}/pkg/main/${PKG}.core.${PVRF}/"
		ln -sv "/pkg/main/${PKG}.core.${PVRF}/udev" "${D}/pkg/main/${PKG}.libs.${PVRF}/$LIB"
	fi

	for foo in $LIBS; do
		if [ -d "${D}/pkg/main/${PKG}.libs.${PVRF}/$foo" ]; then
			# check for any .a file, move to dev
			mkdir -pv "${D}/pkg/main/${PKG}.dev.${PVRF}/$foo"
			if [ "$foo" = lib64 ]; then
				ln -sv lib64 "${D}/pkg/main/${PKG}.dev.${PVRF}/lib"
			fi
			count=$(find "${D}/pkg/main/${PKG}.libs.${PVRF}/$foo" -maxdepth 0 -name '*.a' | wc -l)
			if [ "$count" -gt 0 ]; then
				mv -v "${D}/pkg/main/${PKG}.libs.${PVRF}/$foo"/*.a "${D}/pkg/main/${PKG}.dev.${PVRF}/$foo"
			fi
			# link whatever remains to dev
			for bar in "${D}/pkg/main/${PKG}.libs.${PVRF}/$foo"/*; do
				bar="/pkg/main/${PKG}.libs.${PVRF}/$foo/$(basename "$bar")"
				ln -snfv "$bar" "${D}/pkg/main/${PKG}.dev.${PVRF}/$foo"
			done
		fi
	done

	if [ "${PKG}" != "dev-lang.python" ]; then
		for foo in "pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"/python*/; do
			if [ -d "$foo" ]; then
				# this should be in a python module dir, not here. Let's try to find out what version of python this is and move it around.
				PYTHON=$(basename "$foo") # for example "python3.8"
				VER=$("$PYTHON" --version | awk '{ print $2 }') # 3.8.6 or whatever
				mkdir -pv "pkg/main/${PKG}.mod.${PVRF}.py${VER}/lib"
				mv -v "$foo" "pkg/main/${PKG}.mod.${PVRF}.py${VER}/lib"
			fi
		done
	fi

	for foo in man info share/man share/info; do
		if [ -d "pkg/main/${PKG}.core.${PVRF}/$foo" ]; then
			# this should be in doc
			mkdir -pv "pkg/main/${PKG}.doc.${PVRF}"
			mv -v "pkg/main/${PKG}.core.${PVRF}/$foo" "pkg/main/${PKG}.doc.${PVRF}"
			rmdir "pkg/main/${PKG}.core.${PVRF}/$foo" || true
			rmdir "pkg/main/${PKG}.core.${PVRF}" || true
		fi
	done
}

wipesuid() {
	echo "Wiping suid flag from files..."
	find "${D}" -user root -perm -4000 -print0 | xargs -0 chmod -v ug-s
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
		if [ -d "${D}/pkg/main/${PKG}.core.${PVRF}" ]; then
			cp -vT "${BASEDIR}/azusa.yaml" "${D}/pkg/main/${PKG}.core.${PVRF}/azusa.yaml"
		fi
	fi

	if [ -d "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX" ]; then
		# build .ld.so.cache file
		echo "Building ld.so.cache ..."
		for sub in lib64 lib32 lib; do
			# check if dir but not symlink
			if [ -d "${D}/pkg/main/${PKG}.libs.${PVRF}/$sub" ]; then
				if [ ! -L "${D}/pkg/main/${PKG}.libs.${PVRF}/$sub" ]; then
					echo "/pkg/main/${PKG}.libs.${PVRF}/$sub" >>"${D}/pkg/main/${PKG}.libs.${PVRF}/.ld.so.conf"
				fi
			fi
		done
		if [ -f "${D}/pkg/main/${PKG}.libs.${PVRF}/.ld.so.conf" ]; then
			echo "Running ldconfig..."
			ldconfig --format=new -v -r "${D}" -C "/pkg/main/${PKG}.libs.${PVRF}/.ld.so.cache" -f "/pkg/main/${PKG}.libs.${PVRF}/.ld.so.conf" 
		fi
	fi

	echo "Building squashfs..."
	cd "${D}"

	for foo in "pkg/main/${PKG}".*; do
		squash "$foo"
	done

	if [ x"$HSM" != x ]; then
		apkg-convert $APKGOUT/*.squashfs
	fi
}

finalize() {
	fixelf
	organize
	archive
}

fixelf() {
	if [ ! -f /pkg/main/dev-util.patchelf.core/bin/patchelf ]; then
		echo "FIXELF ERROR: patchelf not found, skipping check"
		return
	fi
	# locate all binaries that have .interp pointing to /lib64/ld-linux-x86-64.so.2
	# and use patchelf to fix it
	# readelf -p .interp /bin/bash | grep ld-linux | awk '{ print $3 }'
	# file /bin/bash
	# /pkg/main/dev-util.patchelf.core/bin/patchelf --print-interpreter /bin/bash
	# /pkg/main/dev-util.patchelf.core/bin/patchelf --set-interpreter /pkg/main/sys-libs.glibc.libs/lib64/ld-linux-x86-64.so.2
	find "${D}" -type f -executable | while read -r fn; do
		local ft
		ft="$(file -b "${fn}")"
		case $ft in
			ELF*dynamically*interpreter*)
				cur="$(/pkg/main/dev-util.patchelf.core/bin/patchelf --print-interpreter "${fn}")"
				case $cur in
					/lib64/ld-linux-x86-64.so.2)
						echo "FIXELF: patching $fn"
						# linux amd64
						/pkg/main/dev-util.patchelf.core/bin/patchelf --set-interpreter /pkg/main/sys-libs.glibc.libs.linux.amd64/lib64/ld-linux-x86-64.so.2 "${fn}"
						;;
					/lib/ld-linux.so.2)
						echo "FIXELF: patching $fn"
						# linux x86
						/pkg/main/dev-util.patchelf.core/bin/patchelf --set-interpreter /pkg/main/sys-libs.glibc.libs.linux.386/lib/ld-linux.so.2 "${fn}"
						;;
					/lib/ld-linux-aarch64.so.1)
						echo "FIXELF: patching $fn"
						# linux arm64
						/pkg/main/dev-util.patchelf.core/bin/patchelf --set-interpreter /pkg/main/sys-libs.glibc.libs.linux.arm64/lib/ld-linux-aarch64.so.1 "${fn}"
						;;
				esac
				;;
		esac
	done
}

cleanup() {
	echo "Cleaning up..."
	rm -fr "${TMPBASE}/${PKG}/${PVRF}"
}

callconf() {
	# try to locate configure
	if [ x"$CONFPATH" != x ]; then
		echo "Calling ${CONFPATH} $@"
		"${CONFPATH}" "$@"
		return
	fi

	if [ -x ./configure ]; then
		echo "Calling ./configure $@"
		./configure "$@"
		return
	fi
	if [ -x "${S}/configure" ]; then
		echo "Calling ${S}/configure $@"
		"${S}/configure" "$@"
		return
	fi
	if [ -x "${CHPATH}/configure" ]; then
		echo "Calling ${CHPATH}/configure $@"
		"${CHPATH}/configure" "$@"
		return
	fi

	CONFPATH=$(echo "${CHPATH}"/*/configure)
	if [ -x "$CONFPATH" ]; then
		echo "Calling ${CONFPATH} $@"
		"${CONFPATH}" "$@"
		return
	fi

	echo "doconf: Could not locate configure"
	exit 1
}

doconf() {
	prepare
	echo "Running configure..."
	callconf --prefix="/pkg/main/${PKG}.core.${PVRF}" --sysconfdir=/etc --localstatedir=/var --host="$CHOST" --build="$CHOST" \
	--includedir="/pkg/main/${PKG}.dev.${PVRF}/include" --libdir="/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX" --datarootdir="/pkg/main/${PKG}.core.${PVRF}/share" \
	--mandir="/pkg/main/${PKG}.doc.${PVRF}/man" --docdir="/pkg/main/${PKG}.doc.${PVRF}/doc" "$@"
}

doconflight() {
	prepare
	echo "Running configure..."
	callconf --prefix="/pkg/main/${PKG}.core.${PVRF}" "$@"
}

doconf213() {
	prepare
	echo "Running configure..."
	callconf --prefix="/pkg/main/${PKG}.core.${PVRF}" --sysconfdir=/etc --host="$CHOST" --build="$CHOST" \
	--includedir="/pkg/main/${PKG}.dev.${PVRF}/include" --libdir="/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX" --datarootdir="/pkg/main/${PKG}.core.${PVRF}/share" \
	--mandir="/pkg/main/${PKG}.doc.${PVRF}/man" "$@"
}

domeson() {
	inherit meson
	domeson "$@" || return $?
}

docmake() {
	inherit cmake
	docmake "$@" || return $?
}

fetchgit() {
	inherit git
	fetchgit "$@" || return $?
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
			local vers=""
			if [[ $foo == */*:* ]]; then
				vers=".$(echo "$foo" | cut -d: -f2)"
				foo="$(echo "$foo" | cut -d: -f1)"
			fi
			vers="${vers}.${OS}.${ARCH}"
			# standard import paths
			if [ -d "/pkg/main/${foo/\//.}.dev${vers}/include" ]; then
				export CPPFLAGS="$CPPFLAGS -I/pkg/main/${foo/\//.}.dev${vers}/include"
				export CPATH="$CPATH:/pkg/main/${foo/\//.}.dev${vers}/include"
				export CMAKE_SYSTEM_INCLUDE_PATH="${CMAKE_SYSTEM_INCLUDE_PATH};/pkg/main/${foo/\//.}.dev${vers}/include"
			fi
			if [ -d "/pkg/main/${foo/\//.}.libs${vers}/lib$LIB_SUFFIX" ]; then
				export LDFLAGS="$LDFLAGS -L/pkg/main/${foo/\//.}.libs${vers}/lib$LIB_SUFFIX"
				export CMAKE_SYSTEM_LIBRARY_PATH="${CMAKE_SYSTEM_LIBRARY_PATH};/pkg/main/${foo/\//.}.libs${vers}/lib$LIB_SUFFIX"
			fi
		elif [ "$foo" = "X" ]; then
			# import all of X11
			local sub=("x11-base/xorg-proto")
			for foo2 in "${ROOTDIR}/x11-libs"/lib*; do
				lib=$(basename "$foo2")
				sub+=("x11-libs/$lib")
			done
			importpkg "${sub[@]}"
		else
			PKGCFG="$PKGCFG $foo"
		fi
	done

	local inc
	local lib

	if [ x"$PKGCFG" != x ]; then
		pkg-config --exists --print-errors "$PKGCFG"
		inc="$(pkg-config --cflags-only-I "$PKGCFG")"
		lib="$(pkg-config --libs-only-L "$PKGCFG")"
		export CPPFLAGS="$CPPFLAGS $inc"
		export LDFLAGS="$LDFLAGS $lib"

		for foo in $inc; do
			# remove -I and add to CMAKE_SYSTEM_INCLUDE_PATH
			export CMAKE_SYSTEM_INCLUDE_PATH="${CMAKE_SYSTEM_INCLUDE_PATH};${foo#-I}"
		done
		for foo in $lib; do
			# remove -L and add to CMAKE_SYSTEM_LIBRARY_PATH
			export CMAKE_SYSTEM_LIBRARY_PATH="${CMAKE_SYSTEM_LIBRARY_PATH};${foo#-L}"
		done
	fi
}

# azusa check
acheck() {
	if [ x"$AZUSA_ALLOW_ENV" != x ]; then
		return
	fi
	envcheck
	# disable networking now that we know we are in a separate env
	# TODO we should actually disable the whole net stack in local namespace
	echo -n >/etc/resolv.conf

}

envcheck() {
	if [ x"$AZUSA_ALLOW_ENV" != x ]; then
		return
	fi
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
	local EXTRAOPT=()
	if [ -d "$S/m4" ]; then
		EXTRAOPT+=(-I "$S/m4")
	fi
	libtoolize --force --install
	autoreconf -fi -I /pkg/main/azusa.symlinks.core/share/aclocal/ "${EXTRAOPT[@]}"
}

die() {
	echo "$@"
	exit 1
}

# eg: makepkgconfig -lduktape
makepkgconfig() {
	local LIBS="$1"
	if [ x"$LIBS" = x ]; then
		die "need to specify libs in makepkgconfig"
	fi

	local PCFILE="$2"
	if [ x"$PCFILE" = x ]; then
		PCFILE="$PN"
	fi
	local NAME="$PN"
	local DESC=""

	if [ -f "$BASEDIR/azusa.yaml" ]; then
		DESC="$(cat "$BASEDIR/azusa.yaml" | grep ^description: | sed -e 's/^description: *//')"
	fi

	local TGT="/pkg/main/${PKG}.dev.${PVRF}/pkgconfig/"
	mkdir -pv "${D}${TGT}"

	echo "Generating file ${TGT}${PCFILE}.pc"

	cat >"${D}${TGT}${PCFILE}.pc" <<EOF
prefix=/pkg/main/${PKG}.core.${PVRF}
exec_prefix=\${prefix}
libdir=/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX
includedir=/pkg/main/${PKG}.dev.${PVRF}/include

Name: $NAME
Description: $DESC
Version: $PV
Libs: -L\${libdir} $LIBS
Cflags: -I\${includedir}
EOF
}
