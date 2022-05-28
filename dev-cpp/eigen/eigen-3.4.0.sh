#!/bin/sh
source "../../common/init.sh"

get https://gitlab.com/lib${PN}/${PN}/-/archive/${PV}/${P}.tar.gz
acheck

cd "${T}"

docmake -DEIGEN_TEST_NO_OPENGL=ON -DCMAKE_DISABLE_FIND_PACKAGE_Cholmod=ON -DEIGEN_TEST_CXX11=ON -DEIGEN_TEST_NOQT=ON -DEIGEN_TEST_ALTIVEC=ON -DEIGEN_TEST_CUDA=ON -DEIGEN_TEST_OPENMP=OFF -DEIGEN_TEST_NEON64=ON -DEIGEN_TEST_VSX=ON

finalize
