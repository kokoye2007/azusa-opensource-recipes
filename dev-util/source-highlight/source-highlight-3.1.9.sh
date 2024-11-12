#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnu.org/pub/gnu/src-highlite/"${P}".tar.gz
acheck

cd "${T}" || exit

importpkg dev-libs/boost

# required as rev-dep of dev-libs/boost-1.62.0
# https://wiki.gentoo.org/wiki/Project:C%2B%2B/Maintaining_ABI
CXXFLAGS="$CXXFLAGS -std=c++14"

doconf --with-boost --with-boost-regex="boost_regex" CXXFLAGS="$CXXFLAGS"

make
make install DESTDIR="${D}"

finalize
