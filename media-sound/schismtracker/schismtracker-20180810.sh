#!/bin/sh
source "../../common/init.sh"

get https://github.com/"${PN}"/"${PN}"/archive/"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${S}" || exit

aautoreconf

sed -e "/^Categories/ s/Audio/AudioVideo;Audio/" -i sys/fd.org/schism.desktop || die

# workaround for temporary files (missing directory). Fixes:
# sh ./scripts/build-font.sh . font/default-lower.fnt font/default-upper-alt.fnt font/default-upper-itf.fnt font/half-width.fnt >auto/default-font.c
# /bin/sh: auto/default-font.c: No such file or directory
mkdir auto

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
