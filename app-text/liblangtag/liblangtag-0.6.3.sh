#!/bin/sh
source "../../common/init.sh"

get https://bitbucket.org/tagoh/"${PN}"/downloads/"${P}".tar.bz2
acheck

cd "${T}" || exit

doconf --disable-static --enable-introspection --disable-gtk-doc --disable-debug

make
make install DESTDIR="${D}"

finalize
