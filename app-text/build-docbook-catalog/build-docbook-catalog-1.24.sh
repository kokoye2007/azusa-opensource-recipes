source ../../common/init.sh

get https://github.com/AzusaOS/"${PN}"/archive/v"${PV}".tar.gz
acheck

cd "$P" || exit

make install PREFIX=/pkg/main/"${PKG}".core."${PVRF}" DESTDIR="${D}"

finalize
