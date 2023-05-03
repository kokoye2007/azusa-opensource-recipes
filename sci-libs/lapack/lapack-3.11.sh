#!/bin/sh
source "../../common/init.sh"

get https://github.com/Reference-LAPACK/lapack/archive/v${PV}.tar.gz ${P}.tar.gz
acheck

cd "${T}"

docmake -DCBLAS=ON -DLAPACKE=ON -DBUILD_DEPRECATED=OFF -DBUILD_SHARED_LIBS=ON -DTEST_FORTRAN_COMPILER=OFF

finalize
