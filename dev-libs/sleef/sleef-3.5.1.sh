#!/bin/sh
source "../../common/init.sh"

get https://github.com/shibatch/${PN}/archive/refs/tags/${PV}.tar.gz ${P}.tar.gz
acheck

cd "${T}"

importpkg dev-libs/mpfr dev-libs/gmp sci-libs/fftw

docmake -DDISABLE_FFTW=ON -DBUILD_QUAD=ON -DBUILD_TESTS=OFF

finalize
