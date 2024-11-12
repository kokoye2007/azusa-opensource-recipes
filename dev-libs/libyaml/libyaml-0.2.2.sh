#!/bin/sh
source "../../common/init.sh"

get https://github.com/yaml/libyaml/archive/"${PV}"/libyaml-dist-"${PV}".tar.gz

cd "${P}" || exit

#./bootstrap
aautoreconf

cd "${T}" || exit

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
