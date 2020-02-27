#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/readline/${PN}-7.0.tar.gz

cd "${PN}-7.0"

for foo in `seq -f '%03.f' 1 5`; do
	get https://ftp.gnu.org/gnu/readline/${PN}-7.0-patches/${PN}70-${foo}
	patch -p0 <"${PN}70-${foo}"
done

acheck

cd "${T}"

# configure & build
doconf --disable-static

make
make install DESTDIR="${D}"

finalize
