#!/bin/sh
source "../../common/init.sh"

get https://github.com/mesonbuild/meson/releases/download/${PV}/${P}.tar.gz

cd "${P}"

python3 setup.py build

python3 setup.py install --root="${D}/pkg/main/${PKG}.${PVR}"

finalize
