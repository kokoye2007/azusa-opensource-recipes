#!/bin/sh
source "../../common/init.sh"

# Patch version
FIREFOX_PATCHSET="firefox-102esr-patches-10j.tar.xz"
SPIDERMONKEY_PATCHSET="spidermonkey-102-patches-05j.tar.xz"

# gentoo vars
MOZ_PV="${PV}esr"
MOZ_PN="firefox"
MOZ_P="${MOZ_PN}-${MOZ_PV}"
MOZ_PV_DISTFILES="${MOZ_PV}${MOZ_PV_SUFFIX}"
MOZ_P_DISTFILES="${MOZ_PN}-${MOZ_PV_DISTFILES}"

MOZ_SRC_BASE_URI="https://archive.mozilla.org/pub/${MOZ_PN}/releases/${MOZ_PV}"

PATCH_URIS=(
	https://dev.gentoo.org/~{juippis,whissi}/mozilla/patchsets/${FIREFOX_PATCHSET}
	https://dev.gentoo.org/~{juippis,whissi}/mozilla/patchsets/${SPIDERMONKEY_PATCHSET}
)

get "${MOZ_SRC_BASE_URI}/source/${MOZ_P}.source.tar.xz" "${MOZ_P_DISTFILES}.source.tar.xz"

for f in $PATCH_URIS; do
	get "$f"
done

acheck

cd "${T}"

"${S}/js/src/configure" --prefix=/pkg/main/${PKG}.core.${PVRF} \
	--includedir=/pkg/main/${PKG}.dev.${PVRF}/include --libdir=/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX \
	--with-intl-api --with-system-zlib --with-system-icu --disable-jemalloc --enable-readline

make
make install DESTDIR="${D}"

finalize
