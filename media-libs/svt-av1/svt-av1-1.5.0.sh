#!/bin/sh
source "../../common/init.sh"

get https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v${PV}/SVT-AV1-v${PV}.tar.bz2
acheck

cd "${T}"

docmake -DBUILD_TESTING=OFF -DENABLE_AVX512=ON

finalize
