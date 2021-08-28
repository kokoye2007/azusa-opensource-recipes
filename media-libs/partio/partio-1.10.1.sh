#!/bin/sh
source "../../common/init.sh"

get https://github.com/wdas/${PN}/archive/v${PV}.tar.gz "${P}.tar.gz"
acheck

cd "${T}"

importpkg gl glu glut zlib dev-cpp/gtest

docmake

finalize
