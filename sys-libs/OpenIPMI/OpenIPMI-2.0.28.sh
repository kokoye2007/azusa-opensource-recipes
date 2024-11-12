#!/bin/sh
source "../../common/init.sh"

get https://sourceforge.net/projects/openipmi/files/OpenIPMI%202.0%20Library/"${P}".tar.gz
acheck

cd "${P}" || exit

apatch "${FILESDIR}/openipmi-2.0.26-tinfo.patch"
aautoreconf

importpkg dev-libs/popt ncurses sys-libs/readline

cd "${T}" || exit

doconf --with-openssl --with-glib=yes --with-perl --with-python || /bin/bash -i

make
make install DESTDIR="${D}"

finalize
