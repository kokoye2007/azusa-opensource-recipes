#/bin/sh
source "../../common/init.sh"

COMMIT=fbcd182dfbadab5076b6a41c21688d9c53a29cc4
fetchgit https://github.com/darlinghq/darling.git $COMMIT
acheck

export CPPFLAGS="${CPPFLAGS} -I/pkg/main/sys-libs.libcxxabi.dev/include/c++/v1/"

cd "${T}"

importpkg X media-libs/freetype zlib media-libs/libpng media-libs/tiff media-libs/libjpeg-turbo media-libs/giflib media-libs/libglvnd media-sound/pulseaudio dev-libs/libbsd app-crypt/libmd sys-libs/libcxxabi

docmake -DTARGET_i386=OFF || /bin/bash -i

finalize
