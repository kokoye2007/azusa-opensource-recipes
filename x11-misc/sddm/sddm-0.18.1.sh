#!/bin/sh
source "../../common/init.sh"

get https://github.com/sddm/sddm/releases/download/v${PV}/${P}.tar.xz
acheck

cd "${S}"

PATCHES=(
	"${FILESDIR}/${PN}-0.12.0-respect-user-flags.patch"
	"${FILESDIR}/${PN}-0.18.0-Xsession.patch" # bug 611210
	"${FILESDIR}/${PN}-0.18.0-sddmconfdir.patch"
	# fix for groups: https://github.com/sddm/sddm/issues/1159
	"${FILESDIR}/${P}-revert-honor-PAM-supplemental-groups.patch"
	"${FILESDIR}/${P}-honor-PAM-supplemental-groups-v2.patch"
	# fix for ReuseSession=true
	"${FILESDIR}/${P}-only-reuse-online-sessions.patch"
	# TODO: fix properly
	"${FILESDIR}/${PN}-0.16.0-ck2-revert.patch" # bug 633920
)

apatch "${PATCHES[@]}"

cd "${T}"

importpkg sys-libs/pam
export CXXFLAGS="${CPPFLAGS} -O2"

docmake -DENABLE_PAM=YES -DNO_SYSTEMD=YES -DUSE_ELOGIND=NO -DBUILD_MAN_PAGES=ON -DDBUS_CONFIG_FILENAME="org.freedesktop.sddm.conf"

make
make install DESTDIR="${D}"

finalize
