#!/bin/sh
source "../../common/init.sh"

get https://dl.bintray.com/boostorg/release/${PV}/source/boost_${PV//./_}.tar.bz2
acheck

importpkg dev-libs/icu zlib app-arch/bzip2 app-arch/xz app-arch/zstd

BOOST_BUILD_PATH="${CHPATH}/boost_${PV//./_}"

cd "$BOOST_BUILD_PATH"

export CPPFLAGS="$CPPFLAGS -I/pkg/main/dev-lang.python.core.3.8/include/python3.8"

# configure & build
./bootstrap.sh --with-icu=/pkg/main/dev-libs.icu.core --with-python=python3.8 --with-python-root=/pkg/main/dev-lang.python.core.3.8/ --with-python-version=3.8 --prefix="/pkg/main/${PKG}.core.${PVRF}" --libdir="/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX" --includedir="/pkg/main/${PKG}.dev.${PVRF}/include"

# create user-config.jam
cat >>user-config.jam <<EOF
using gcc : $(gcc -dumpversion) : /bin/gcc : <cflags>"${CFLAGS}" <cxxflags>"${CPPFLAGS} ${CXXFLAGS}" <linkflags>"${CPPFLAGS} ${LDFLAGS} -lstdc++" ;
using mpi ;
using python : 3.8 : python3.8 : /pkg/main/dev-lang.python.core.3.8/include/python3.8 : /pkg/main/dev-lang.python.libs.3.8/lib$LIB_SUFFIX ;
EOF

#ICU_PATH="/pkg/main/dev-libs.icu.core"
#ICU_LINK="$(pkg-config --libs icu-uc)"

B2_OPTS=(
	-q -d+2
	--ignore-site-config
	-sICU_PATH="/pkg/main/dev-libs.icu.dev"
	--user-config="${BOOST_BUILD_PATH}/user-config.jam"
	--without-stacktrace
	--layout=system
	--no-cmake-config
	cxxflags="$CPPFLAGS -std=c++14"
	library-path="/pkg/main/dev-libs.icu.libs/lib$LIB_SUFFIX"
	threading=multi
	link=shared
)

./b2 "${B2_OPTS[@]}" stage -j"$NPROC"
./b2 "${B2_OPTS[@]}" install --prefix="${D}/pkg/main/${PKG}.core.${PVRF}" --libdir="${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX" --includedir="${D}/pkg/main/${PKG}.dev.${PVRF}/include"

finalize
