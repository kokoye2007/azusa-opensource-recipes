#!/bin/sh
source "../../common/init.sh"

get https://github.com/nemtrif/${PN}/archive/v${PV}.tar.gz
acheck

cd "${P}"

sed -e "/add_subdirectory(extern\/gtest)/d" -i CMakeLists.txt
sed -e "s/gtest_main/gtest &/" -i tests/CMakeLists.txt

cd "${T}"

docmake -DUTF8_SAMPLES=OFF -DUTF8_TESTS=OFF

make
make install DESTDIR="${D}"

finalize
