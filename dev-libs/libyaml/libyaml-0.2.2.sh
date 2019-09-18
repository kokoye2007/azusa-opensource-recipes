#!/bin/sh
source "../../common/init.sh"

get https://github.com/yaml/libyaml/archive/${PV}/libyaml-dist-${PV}.tar.gz

cd "${P}"

./bootstrap

cd "${T}"

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
