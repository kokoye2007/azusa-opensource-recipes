#!/bin/sh
source "../../common/init.sh"

get https://download.qt.io/official_releases/qt/${PV%.*}/${PV}/submodules/${PN}-everywhere-src-${PV}.tar.xz
acheck

# fix missing qt_version_tag symbol w/ LTO, bug 674382
sed -i -e 's/^gcc:ltcg/gcc/' "${S}/src/corelib/global/global.pri"

# alter $S/qtbase/mkspecs/common/gcc-base.conf
cat >>"$S/mkspecs/common/gcc-base.conf" <<EOF
eval(QMAKE_CFLAGS_RELEASE += \$\$(CPPFLAGS))
eval(QMAKE_LFLAGS_RELEASE += \$\$(LDFLAGS))
EOF

importpkg libevent

cd "${T}"

# https://doc.qt.io/qt-5/configure-options.html
CONFIGURE=(
	-prefix "/pkg/main/${PKG}.core.${PVRF}"
	-headerdir "/pkg/main/${PKG}.dev.${PVRF}/include"
	-libdir "/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
	-plugindir "/pkg/main/${PKG}.libs.${PVRF}/plugins"
	-docdir "/pkg/main/${PKG}.libs.${PVRF}/doc"
	-examplesdir "/pkg/main/${PKG}.doc.${PVRF}/examples"
	-no-compile-examples

	-platform linux-g++
	-no-feature-statx # gentoo bug 672856
	-opensource
	-confirm-license
	-release
	-shared

	-pkg-config
	-glib
	-icu
	-ssl
	-openssl-linked
	-dbus-linked

	# Third-Party Libraries
	-system-zlib
	-system-libjpeg
	-system-libpng
	-system-xcb
	-system-freetype
	-system-pcre
	-system-harfbuzz
	-system-doubleconversion # thirdparty
	-system-sqlite # db

	# required for -gtk
	-L/pkg/main/sys-libs.zlib.libs/lib$LIB_SUFFIX
	-L/pkg/main/x11-libs.libX11.libs/lib$LIB_SUFFIX
	-L/pkg/main/x11-libs.libXext.libs/lib$LIB_SUFFIX

	# required for qtmultimedia:
	# /pkg/main/media-libs.gst-plugins-base.core.1.16.2.linux.amd64/include/gstreamer-1.0/gst/gl/wayland/gstgldisplay_wayland.h:26:10: fatal error: wayland-client.h: No such file or directory
	-I/pkg/main/dev-libs.wayland.dev/include

	# libs, etc: qtbase
	DBUS_PREFIX=/pkg/main/sys-apps.dbus.dev
	LIBUDEV_PREFIX=/pkg/main/sys-fs.udev.dev
	ZLIB_PREFIX=/pkg/main/sys-libs.zlib.dev
	ZSTD_PREFIX=/pkg/main/app-arch.zstd.dev
	DOUBLECONVERSION_PREFIX=/pkg/main/dev-libs.double-conversion.dev
	ICU_PREFIX=/pkg/main/dev-libs.icu.dev
	PCRE2_PREFIX=/pkg/main/dev-libs.libpcre2.dev
	OPENSSL_PREFIX=/pkg/main/dev-libs.openssl.dev

	# gui
	HARFBUZZ_PREFIX=/pkg/main/media-libs.harfbuzz.dev
	# LIBMD4C_PREFIX
	# OpenVG → mesa?
	OPENGL_PREFIX=/pkg/main/media-libs.mesa.dev # ?
	# vulkan
	LIBINPUT_PREFIX=/pkg/main/dev-libs.libinput.dev
	# TSLIB_PREFIX → x11-libs/tslib
	XCB_PREFIX=/pkg/main/x11-libs.libxcb.dev

	# sqldrivers
	MYSQL_PREFIX=/pkg/main/dev-db.mariadb.dev
)

callconf "${CONFIGURE[@]}" | tee configure.log

# trick to make errors shown in red in make
make -j"$NPROC" || /bin/bash -i
#	2> >(while IFS='' read -r line; do echo -e "\e[01;31m$line\e[0m" >&2; done)
make install DESTDIR="${D}"

organize

echo "TODO → split Qt into per-module files"
/bin/bash -i


archive
