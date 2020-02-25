#!/bin/sh
source "../../common/init.sh"

get https://dl.bintray.com/boostorg/release/${PV}/source/boost_${PV//./_}.tar.bz2
acheck

importpkg dev-libs/icu zlib app-arch/bzip2 app-arch/xz app-arch/zstd

BOOST_BUILD_PATH="${CHPATH}/boost_${PV//./_}"

cd "$BOOST_BUILD_PATH"

export CPPFLAGS="$CPPFLAGS -I/pkg/main/dev-lang.python.core.2.7/include/python2.7"

# configure & build
./bootstrap.sh --with-icu=/pkg/main/dev-libs.icu.core --with-python=python2.7 --with-python-root=/pkg/main/dev-lang.python.core.2.7/ --with-python-version=2.7 --prefix="/pkg/main/${PKG}.core.${PVR}" --libdir="/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX" --includedir="/pkg/main/${PKG}.dev.${PVR}/include"

# create user-config.jam
cat >>user-config.jam <<EOF
using gcc : $(gcc -dumpversion) : /bin/gcc : <cflags>"${CFLAGS}" <cxxflags>"${CPPFLAGS} ${CXXFLAGS}" <linkflags>"${CPPFLAGS} ${LDFLAGS}" ;
using mpi ;
using python : 2.7 : python2.7 : /pkg/main/dev-lang.python.core.2.7/include/python2.7 : /pkg/main/dev-lang.python.libs.2.7/lib$LIB_SUFFIX ;
using python : 3.7 : python3.7 : /pkg/main/dev-lang.python.core.3.7/include/python3.7m : /pkg/main/dev-lang.python.libs.3.7/lib$LIB_SUFFIX ;
EOF

ICU_PATH="/pkg/main/dev-libs.icu.core"
ICU_LINK="$(pkg-config --libs icu-uc)"

./b2 --ignore-site-config --user-config="${BOOST_BUILD_PATH}/user-config.jam" -sICU_PATH="$ICU_PATH" -sICU_LINK="$ICU_LINK" stage threading=multi link=shared -j8
./b2 --ignore-site-config --user-config="${BOOST_BUILD_PATH}/user-config.jam" -sICU_PATH="$ICU_PATH" -sICU_LINK="$ICU_LINK" install link=shared --prefix="${D}/pkg/main/${PKG}.core.${PVR}"

finalize
