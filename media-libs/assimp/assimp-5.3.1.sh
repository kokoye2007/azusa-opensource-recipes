#!/bin/sh
source "../../common/init.sh"

get https://github.com/"${PN}"/"${PN}"/archive/v"${PV}".tar.gz "${P}".tar.gz

PATCHES=(
	"${FILESDIR}"/${PN}-5.2.5-disable-failing-tests.patch
	"${FILESDIR}"/${PN}-5.2.5-disable-collada-tests.patch
)

cd "${S}" || exit

apatch "${PATCHES[@]}"

acheck

cd "${T}" || exit

importpkg zlib

docmake -DASSIMP_ASAN=OFF -DASSIMP_BUILD_ASSIMP_TOOLS=ON -DASSIMP_BUILD_DOCS=OFF -DASSIMP_BUILD_SAMPLES=OFF -DASSIMP_BUILD_TESTS=OFF -DASSIMP_BUILD_ZLIB=OFF -DASSIMP_DOUBLE_PRECISION=OFF -DASSIMP_INJECT_DEBUG_POSTFIX=OFF -DASSIMP_IGNORE_GIT_HASH=ON -DASSIMP_UBSAN=OFF -DASSIMP_WARNINGS_AS_ERRORS=OFF -DASSIMP_BUILD_COLLADA_IMPORTER=OFF -DASSIMP_BUILD_COLLADA_EXPORTER=OFF

finalize
