#!/bin/sh
source "../../common/init.sh"

get https://github.com/ArtifexSoftware/${PN}/archive/${PV}.tar.gz ${P}.tar.gz
acheck

cd "${S}"

# We only need configure.ac and config_types.h.in
sed -i \
	-e '/^# do we need automake?/,/^autoheader/d' \
	-e '/echo "  $AUTOM.*/,$d' \
	autogen.sh

./autogen.sh
aautoreconf

cd "${T}"

doconf --enable-static --with-libpng

make
make install DESTDIR="${D}"

finalize
