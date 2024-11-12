#!/bin/sh
source "../../common/init.sh"

get https://github.com/opencv/"${PN}"/archive/"${PV}".tar.gz
acheck

cd "${T}" || exit

docmake -DBUILD_SHARED_LIBS=ON -DOPENCV_GENERATE_PKGCONFIG=YES

make -j"$NPROC"
make install DESTDIR="${D}"

finalize
