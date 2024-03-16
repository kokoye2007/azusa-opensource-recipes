#/bin/sh
source "../../common/init.sh"

get http://zlib.net/${P}.tar.gz
acheck

cd "${T}"

# configure & build
doconflight
make
make install DESTDIR=${D}

finalize
