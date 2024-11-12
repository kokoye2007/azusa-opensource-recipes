#!/bin/sh
source "../../common/init.sh"

get https://dl.matroska.org/downloads/libmatroska/"${P}".tar.xz
acheck

cd "${T}" || exit

# -DEbml_DIR=
docmake -DBUILD_SHARED_LIBS=YES -DEBML_DIR=/pkg/main/dev-libs.libebml.core/lib64/cmake/EBML

make
make install DESTDIR="${D}"

finalize
