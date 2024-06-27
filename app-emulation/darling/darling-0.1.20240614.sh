#/bin/sh
source "../../common/init.sh"

COMMIT=203af1f604727e13032df1870e3491572e7d6704
fetchgit https://github.com/darlinghq/darling.git $COMMIT
acheck

export CPPFLAGS="${CPPFLAGS} -I/pkg/main/sys-libs.libcxxabi.dev/include/c++/v1/"

cd "${S}"

sed -i '/-Werror/d' src/external/corecrypto/CMakeLists.txt
sed -i 's/libpng.so/libpng16.so/' src/native/CMakeLists.txt

cd "${T}"

importpkg X media-libs/freetype zlib media-libs/libpng media-libs/tiff media-libs/libjpeg-turbo media-libs/giflib media-libs/libglvnd media-sound/pulseaudio dev-libs/libbsd app-crypt/libmd sys-libs/libcxxabi media-libs/fontconfig

# make darling's wrapgen work
export LD_LIBRARY_PATH="$LIBRARY_PATH"

docmake -DBUILD_SHARED_LIBS=OFF -DTARGET_i386=OFF -DCMAKE_BUILD_TYPE=Debug || /bin/bash -i

# cd /build/darling-0.1.20240614/temp/src/native && /build/darling-0.1.20240614/temp/src/libelfloader/wrapgen/wrapgen libpng.so /build/darling-0.1.20240614/temp/src/native/png.c /build/darling-0.1.20240614/temp/src/native/png_vars.h
# Cannot load libpng.so: libpng.so: cannot open shared object file: No such file or directory

finalize
