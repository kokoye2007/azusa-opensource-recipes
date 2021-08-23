#!/bin/sh
source "../../common/init.sh"

get "https://github.com/imageworks/Field3D/archive/v${PV}.tar.gz" "${P}.tar.gz"
acheck

cd "${S}"

apatch "$FILESDIR/${P}-Use-PkgConfig-for-IlmBase.patch"

cd "${T}"

importpkg dev-libs/boost media-libs/openexr dev-libs/imath zlib

docmake -DINSTALL_DOCS=OFF -DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=ON

finalize
