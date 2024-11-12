#/bin/sh
source "../../common/init.sh"

get http://zlib.net/"${P}".tar.gz
acheck

cd "${T}" || exit

# configure & build
doconflight
make
make install DESTDIR="${D}"

finalize
