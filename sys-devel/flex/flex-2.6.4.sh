#!/bin/sh
source "../../common/init.sh"

get https://github.com/westes/flex/files/981163/"${P}".tar.gz
sed -i "/math.h/a #include <malloc.h>" "${P}"/src/flexdef.h

cd "${T}" || exit

# configure & build
HELP2MAN=/bin/true doconf

make
make install DESTDIR="${D}"

# create a lex → flex symlink
ln -snf flex "${D}/pkg/main/${PKG}.core.${PVRF}/bin/lex"

finalize
