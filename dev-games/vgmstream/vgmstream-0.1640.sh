#!/bin/sh
source "../../common/init.sh"

G719_COMMIT="9bd89f89df4a5c0e9f178c173fc55d373f039bcf"
ATRAC9_COMMIT="6a9e00f6c7abd74d037fd210b6670d3cdb313049"

get https://github.com/vgmstream/vgmstream/archive/refs/tags/r"${PV/*.}".tar.gz

# download dependencies in $S
cd "${S}" || exit
get https://github.com/kode54/libg719_decode/archive/$G719_COMMIT.tar.gz
get https://github.com/Thealexbarney/LibAtrac9/archive/$ATRAC9_COMMIT.tar.gz

acheck

# some deps are found but ldflags not set properly
importpkg media-video/ffmpeg media-sound/mpg123 media-libs/libogg media-libs/libvorbis media-libs/speex

cd "${S}/LibAtrac9-${ATRAC9_COMMIT}/C" || exit
mkdir bin
make static CFLAGS="-fPIC" BINDIR="${PWD}/bin"

cd "${T}" || exit

docmake -DBUILD_AUDACIOUS=OFF -DG719_PATH="${S}/libg719_decode-${G719_COMMIT}" -DATRAC9_PATH="${S}/LibAtrac9-${ATRAC9_COMMIT}"

finalize
