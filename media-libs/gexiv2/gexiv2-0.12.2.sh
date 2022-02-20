#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnome.org/pub/gnome/sources/${PN}/${PV%.*}/${P}.tar.xz
acheck

cd "${T}"

# -Dtools=false ?
# Prevents installation of python modules (uses install_data from meson which does not optimize the modules)
# TODO fix docbook & gtkdoc
domeson -Dpython2_girdir=no -Dpython3_girdir=no -Dgtk_doc=false -Dintrospection=true -Dvapi=true

finalize
