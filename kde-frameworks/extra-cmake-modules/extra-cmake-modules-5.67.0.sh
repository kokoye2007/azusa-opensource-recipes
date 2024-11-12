#!/bin/sh
source "../../common/init.sh"

get https://download.kde.org/stable/"${CATEGORY#kde-}"/"${PV%.*}"/"${P}".tar.xz
acheck

cd "${S}" || exit

sed -i '/"lib64"/s/64//' kde-modules/KDEInstallDirs.cmake
sed -e '/PACKAGE_INIT/i set(SAVE_PACKAGE_PREFIX_DIR "${PACKAGE_PREFIX_DIR}")' \
    -e '/^include/a set(PACKAGE_PREFIX_DIR "${SAVE_PACKAGE_PREFIX_DIR}")' \
    -i ECMConfig.cmake.in

cd "${T}" || exit

docmake

finalize
