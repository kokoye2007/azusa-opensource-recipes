#!/bin/sh
source "../../common/init.sh"

get https://github.com/opencv/${PN}/archive/${PV}.tar.gz

cd "${T}"

importcmakepkg sys-libs/zlib

docmake -DBUILD_SHARED_LIBS=ON -DOPENCV_GENERATE_PKGCONFIG=YES

make -j"$NPROC"
make install DESTDIR="${D}"

finalize
