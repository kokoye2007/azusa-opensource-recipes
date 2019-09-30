source ../../common/init.sh

get https://dev.gentoo.org/~haubi/distfiles/${P}.tar.xz
acheck

cd "$P"

make install EPREFIX=/pkg/main/${PKG}.core.${PVR} DESTDIR="${D}"

finalize
