#!/bin/sh
source "../../common/init.sh"

get https://github.com/ibus/ibus/releases/download/"${PV}"/"${P}".tar.gz
acheck

cd "${T}" || exit

importpkg libbsd app-arch/bzip2 uuid xi

doconf --with-unicode-emoji-dir=/pkg/main/app-i18n.unicode-emoji.core/share/unicode/emoji --with-emoji-annotation-dir=/pkg/main/app-i18n.unicode-cldr.core/share/unicode/cldr/common/annotations --with-ucd-dir=/pkg/main/app-i18n.unicode-ucd/share/unicode/ucd

make
make install DESTDIR="${D}"

finalize
