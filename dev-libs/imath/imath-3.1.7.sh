#!/bin/sh
source "../../common/init.sh"

get https://github.com/AcademySoftwareFoundation/"${PN^}"/archive/refs/tags/v"${PV}".tar.gz "${P}.tar.gz"
acheck

PYTHON3="$(realpath "$(which python3)")"
PYTHON3CFG="$(dirname "$PYTHON3")/python3-config"
PYTHON_VERSION="$($PYTHON3 --version | awk '{ print $2 }')"
PYINCLUDES="$("$PYTHON3CFG" --includes | awk '{ print $1 }' | sed -e 's/-I//')"

cd "${T}" || exit

docmake -DBUILD_SHARED_LIBS=ON -DIMATH_ENABLE_LARGE_STACK=ON -DIMATH_HALF_USE_LOOKUP_TABLE=ON -DIMATH_INSTALL_PKG_CONFIG=ON -DIMATH_USE_CLANG_TIDY=OFF -DIMATH_USE_NOEXCEPT=ON \
	-DPYTHON=ON -DPython3_EXECUTABLE="$PYTHON3" -DPython3_INCLUDE_DIR="$PYINCLUDES" -DPython3_LIBRARY=/pkg/main/dev-lang.python.libs."$PYTHON_VERSION"/lib"$LIB_SUFFIX"

finalize
