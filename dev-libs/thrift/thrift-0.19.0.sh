#!/bin/sh
source "../../common/init.sh"

get https://archive.apache.org/dist/"${PN}"/"${PV}"/"${P}".tar.gz
acheck

cd "${T}" || exit

importpkg zlib dev-libs/boost

docmake -DBUILD_CPP=ON -DBUILD_C_GLIB=OFF -DBUILD_JAVA=OFF -DBUILD_JAVASCRIPT=OFF -DBUILD_NODEJS=OFF -DBUILD_PYTHON=OFF -DBUILD_TESTING=OFF -DWITH_LIBEVENT=ON -DWITH_OPENSSL=ON -DWITH_ZLIB=ON -Wno-dev

finalize
