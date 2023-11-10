#/bin/sh
source "../../common/init.sh"

COMMIT=141c24aaa8187b4787cd1f0b002aeac0f35c43eb
fetchgit https://github.com/darlinghq/darling.git $COMMIT
acheck

export CPPFLAGS="${CPPFLAGS} -I/pkg/main/sys-libs.libcxxabi.dev/include/c++/v1/"

cd "${S}"

sed -i '/-Werror/d' src/external/corecrypto/CMakeLists.txt

cd "${T}"

importpkg X media-libs/freetype zlib media-libs/libpng media-libs/tiff media-libs/libjpeg-turbo media-libs/giflib media-libs/libglvnd media-sound/pulseaudio dev-libs/libbsd app-crypt/libmd sys-libs/libcxxabi media-libs/fontconfig

# make darling's wrapgen work
export LD_LIBRARY_PATH="$LIBRARY_PATH"

docmake -DBUILD_SHARED_LIBS=OFF -DTARGET_i386=OFF -DCMAKE_BUILD_TYPE=Debug || /bin/bash -i

finalize
