#!/bin/sh
source "../../common/init.sh"
inherit python

CommitId=0a92994d729ff76a58f692d3028ca1b64b145d91

get https://github.com/Maratyszcza/"${PN}"/archive/${CommitId}.tar.gz "${P}".tar.gz
acheck

importpkg dev-libs/psimd

cd "${S}" || exit

apatch "$FILESDIR/$P-gentoo.patch"

mkdir -p module/fp16
cp -v include/fp16/*py module/fp16

cd "${T}" || exit

importpkg zlib

docmake -DFP16_BUILD_BENCHMARKS=OFF -DFP16_BUILD_TESTS=OFF

python_domodule "${S}/module/fp16"

finalize
