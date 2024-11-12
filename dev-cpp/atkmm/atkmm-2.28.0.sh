#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/atkmm/2.28/"${P}".tar.xz

cd "${P}" || exit

sed -e "/^libdocdir =/ s/\$(book_name)/atkmm-${P}/" -i doc/Makefile.in

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
