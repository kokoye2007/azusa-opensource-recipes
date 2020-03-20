#!/bin/sh
source "../../common/init.sh"

MY_P="webkitgtk-${PV}"
get https://www.webkitgtk.org/releases/${MY_P}.tar.xz
acheck

importpkg dev-libs/icu

cd "${T}"

CMAKE_OPTS=(
	-DENABLE_UNIFIED_BUILDS=OFF # jumbo-build?
	-DENABLE_QUARTZ_TARGET=OFF
	-DENABLE_API_TESTS=OFF
	-DENABLE_GTKDOC=ON
	-DENABLE_GEOLOCATION=ON
	-DENABLE_GLES2=ON # gles2-only?
	-DENABLE_VIDEO=ON
	-DENABLE_WEB_AUDIO=ON
	-DENABLE_INTROSPECTION=ON
	-DUSE_LIBNOTIFY=ON
	-DUSE_LIBSECRET=ON
	-DUSE_OPENJPEG=ON
	-DUSE_WOFF2=ON
	-DENABLE_SPELLCHECK=ON
	-DENABLE_WAYLAND_TARGET=ON
	-DUSE_WPE_RENDERER=ON # WPE renderer is used to implement accelerated compositing under wayland
	-DENABLE_X11_TARGET=ON
	-DENABLE_OPENGL=ON
	-DENABLE_WEBGL=ON
	-DENABLE_BUBBLEWRAP_SANDBOX=ON
	-DBWRAP_EXECUTABLE="/pkg/main/sys-apps.bubblewrap.core/bin/bwrap" # If bubblewrap[suid] then portage makes it go-r and cmake find_program fails with that
	-DCMAKE_BUILD_TYPE=Release
	-DPORT=GTK
)

docmake "${CMAKE_OPTS[@]}"

make
make install DESTDIR="${D}"

finalize
