#!/bin/sh
source "../../common/init.sh"

get https://github.com/opencv/${PN}/archive/${PV}.tar.gz
acheck

cd "${T}"

docmake -DBUILD_SHARED_LIBS=ON -DOPENCV_GENERATE_PKGCONFIG=YES

finalize
