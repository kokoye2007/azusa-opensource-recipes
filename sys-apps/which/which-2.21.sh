#!/bin/sh
source "../../common/init.sh"

get https://carlowood.github.io/which/${P}.tar.gz

cd "${T}"

if [ "$BITS" -eq 32 ]; then
	export CFLAGS="-D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -O2 -pipe -Wall"
fi

doconf

make
make install DESTDIR="${D}"

finalize
