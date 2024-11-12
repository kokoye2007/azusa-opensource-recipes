#!/bin/sh
source "../../common/init.sh"

get https://dev.gentoo.org/~sultan/distfiles/dev-util/gn/"${P}".tar.xz
acheck

cd "${S}" || exit

export CC=gcc
export CXX=g++

python build/gen.py --no-last-commit-position --no-strip --no-static-libstdc++ --allow-warnings

cat >out/last_commit_position.h <<-EOF || die
#ifndef OUT_LAST_COMMIT_POSITION_H_
#define OUT_LAST_COMMIT_POSITION_H_
#define LAST_COMMIT_POSITION_NUM ${PV##0.}
#define LAST_COMMIT_POSITION "${PV}"
#endif  // OUT_LAST_COMMIT_POSITION_H_
EOF

ninja -C out gn

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
mv out/gn "${D}/pkg/main/${PKG}.core.${PVRF}/bin"

mkdir -p "${D}/pkg/main/${PKG}.doc.${PVRF}"
cp -r AUTHORS LICENSE OWNERS README.md docs examples "${D}/pkg/main/${PKG}.doc.${PVRF}"

finalize
