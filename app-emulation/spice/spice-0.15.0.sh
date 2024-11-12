#!/bin/sh
source "../../common/init.sh"

get https://www.spice-space.org/download/releases/spice-server/"${P}".tar.bz2
acheck

inherit asciidoc

cd "${T}" || exit

importpkg libjpeg zlib openssl libsasl2

# meson build script is broken and looks for ./doxygen.sh which is not included in the source
doconf --enable-lz4 --with-sasl --enable-smartcard --enable-gstreamer=1.0 --disable-celt051

make
make install DESTDIR="${D}"

finalize
