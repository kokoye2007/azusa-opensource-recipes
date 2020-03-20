# Cmake utils

cmakeenv() {
	# export a bunch of package ENV vars so cmake is easier to use
	export LibRHash_ROOT=/pkg/main/app-crypt.rhash.dev ZLIB_ROOT=/pkg/main/sys-libs.zlib.dev LibArchive_ROOT=/pkg/main/app-arch.libarchive.dev JsonCpp_ROOT=/pkg/main/dev-libs.jsoncpp.dev LibUV_ROOT=/pkg/main/dev-libs.libuv.dev
	export X11_ROOT=/pkg/main/x11-libs.libX11.dev ALSA_ROOT=/pkg/main/media-libs.alsa-lib.dev XKBFile_ROOT=/pkg/main/x11-libs.libxkbfile.dev XShm_ROOT=/pkg/main/x11-libs.libXext.dev Xinerama_ROOT=/pkg/main/x11-libs.libXinerama.dev
	export Xext_ROOT=/pkg/main/x11-libs.libXext.dev Xcursor_ROOT=/pkg/main/x11-libs.libXcursor.dev Xv_ROOT=/pkg/main/x11-libs.libXv.dev Xi_ROOT=/pkg/main/x11-libs.libXi.dev Xrender_ROOT=/pkg/main/x11-libs.libXrender.dev
	export XRandR_ROOT=/pkg/main/x11-libs.libXrandr.dev Xfixes_ROOT=/pkg/main/x11-libs.libXfixes.dev Freetype_ROOT=/pkg/main/media-libs.freetype.dev
	export JPEG_ROOT=/pkg/main/media-libs.libjpeg-turbo.dev PNG_ROOT=/pkg/main/media-libs.libpng.dev TIFF_ROOT=/pkg/main/media-libs.tiff.dev OpenJPEG_ROOT=/pkg/main/media-libs.openjpeg.dev
	export Boost_ROOT=/pkg/main/dev-libs.boost.dev HTTP_Parser_ROOT=/pkg/main/net-libs.http-parser.dev Xapian_ROOT=/pkg/main/dev-libs.xapian.dev
	export Z3_ROOT=/pkg/main/sci-mathematics.z3.dev PCRE_ROOT=/pkg/main/dev-libs.libpcre.dev PAM_ROOT=/pkg/main/sys-libs.pam.dev Iconv_ROOT=/pkg/main/sys-libs.glibc.dev
	export LZO_ROOT=/pkg/main/dev-libs.lzo.dev SDL2_ROOT=/pkg/main/media-libs.libsdl2.dev Gettext_ROOT=/pkg/main/sys-devel.gettext.dev
	export GnuTLS_ROOT=/pkg/main/net-libs.gnutls.dev Lua_ROOT=/pkg/main/dev-lang.lua.dev Php_ROOT=/pkg/main/dev-lang.php.dev.embed Aspell_ROOT=/pkg/main/app-text.aspell.dev
	export Curses_ROOT=/pkg/main/sys-libs.ncurses.dev OpenGL_ROOT=/pkg/main/media-libs.mesa.dev LibGPGError_ROOT=/pkg/main/dev-libs.libgpg-error.dev
	export Gcrypt_ROOT=/pkg/main/dev-libs.libgcrypt.dev Argon2_ROOT=/pkg/main/app-crypt.argon2.dev QREncode_ROOT=/pkg/main/media-gfx.qrencode.dev
	export YubiKey_ROOT=/pkg/main/sys-auth.libyubikey.dev
	export ECM_DIR=/pkg/main/kde-frameworks.extra-cmake-modules.core/share/ECM/cmake
}

docmake() {
	echo "Running cmake..."
	if [ x"$CMAKE_ROOT" = x ]; then
		CMAKE_ROOT="${S}"
	fi

	cmakeenv

	cmake "$CMAKE_ROOT" \
		-DCMAKE_INSTALL_PREFIX="/pkg/main/${PKG}.core.${PVR}" \
		-DCMAKE_BUILD_TYPE=Release \
		-DBUILD_SHARED_LIBS=ON \
		-DLIB_SUFFIX="$LIB_SUFFIX" \
		"$@" || return $?
}
