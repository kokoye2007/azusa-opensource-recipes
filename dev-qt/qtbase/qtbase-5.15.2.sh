#!/bin/sh
source "../../common/init.sh"

get https://download.qt.io/official_releases/qt/"${PV%.*}"/"${PV}"/submodules/"${PN}"-everywhere-src-"${PV}".tar.xz
acheck

cd "${S}" || exit

# fix missing qt_version_tag symbol w/ LTO, bug 674382
sed -i -e 's/^gcc:ltcg/gcc/' "${S}/src/corelib/global/global.pri"

apatch "$FILESDIR/qtcore-5.15.2-gcc11.patch"

importpkg zlib libevent

# alter $S/qtbase/mkspecs/common/gcc-base.conf
cat >>"$S/mkspecs/common/gcc-base.conf" <<EOF
eval(QMAKE_CFLAGS_RELEASE += \$\$(CPPFLAGS))
eval(QMAKE_LFLAGS_RELEASE += \$\$(LDFLAGS))
EOF

cd "${T}" || exit

# https://doc.qt.io/qt-5/configure-options.html
CONFIGURE=(
	-prefix "/pkg/main/${PKG}.core.${PVRF}"
	-headerdir "/pkg/main/${PKG}.dev.${PVRF}/include"
	-libdir "/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
	-plugindir "/pkg/main/${PKG}.libs.${PVRF}/plugins"
	-docdir "/pkg/main/${PKG}.doc.${PVRF}/doc"
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
	-icu ICU_PREFIX=/pkg/main/dev-libs.icu.dev
	-ssl
	-openssl-linked OPENSSL_PREFIX=/pkg/main/dev-libs.openssl.dev
	-dbus-linked

	# Third-Party Libraries
	-system-zlib ZLIB_PREFIX=/pkg/main/sys-libs.zlib.dev

	# required for -gtk
	-L/pkg/main/x11-libs.libX11.libs/lib$LIB_SUFFIX
	-L/pkg/main/x11-libs.libXext.libs/lib$LIB_SUFFIX


	-system-libjpeg
	-system-libpng
	-system-freetype
	-system-pcre
	-system-harfbuzz HARFBUZZ_PREFIX=/pkg/main/media-libs.harfbuzz.dev
	-system-doubleconversion DOUBLECONVERSION_PREFIX=/pkg/main/dev-libs.double-conversion.dev
	-system-sqlite # db
)

callconf "${CONFIGURE[@]}"

make -j"$NPROC" || /bin/bash -i
make install INSTALL_ROOT="${D}"

echo "check plugins in ${D}/pkg/main/${PKG}.libs.${PVRF}/plugins"
/bin/bash -i

finalize
