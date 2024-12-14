#!/bin/sh
source "../../common/init.sh"
# this is only the base llvm

CATEGORY=sys-devel PN=llvm get https://github.com/llvm/llvm-project/releases/download/llvmorg-${PV}/llvm-project-${PV}.src.tar.xz
acheck

S="$S/llvm"

cd "${T}"

importpkg libxml-2.0 icu-uc sci-mathematics/z3 zlib dev-libs/libedit

# Testing the c++ compiler:
# echo -e '#include <iostream>\nint main() { std::cout << "hello world" << std::endl; return 0; }' | /pkg/main/sys-devel.llvm-bootstrap.data/bin/clang++ -x c++ -o test -

# somehow, clang fails to find the system includes at some point
#export CPPFLAGS="${CPPFLAGS} -isystem /pkg/main/sys-libs.glibc.dev.${OS}.${ARCH}/include"
export C_INCLUDE_PATH="$C_INCLUDE_PATH:/pkg/main/sys-libs.glibc.dev.${OS}.${ARCH}/include"

# do we already have a boostrapped llvm?
if [ -d /pkg/main/sys-devel.llvm-bootstrap.data ]; then
	#export CC=/pkg/main/sys-devel.llvm-bootstrap.data/bin/clang
	TRIPLE="$(gcc -dumpmachine)"
	# ensure -lc++ can be found
	export LIBRARY_PATH="${LIBRARY_PATH}:/pkg/main/sys-devel.llvm-bootstrap.data/lib$LIB_SUFFIX/$TRIPLE"
else
	# fallback on hopefully installed libcxx
	export LIBRARY_PATH="${LIBRARY_PATH}:/pkg/main/sys-libs.libcxx.libs/lib$LIB_SUFFIX:/pkg/main/sys-libs.libcxxabi.libs/lib$LIB_SUFFIX"
fi

# importpkg will set CPPFLAGS but that's not read by llvm
export CFLAGS="${CPPFLAGS}"
export CXXFLAGS="${CPPFLAGS}"

# make sure previous config doesn't cause issues
rm -fr /pkg/main/${PKG}.data.${PVRF}/config

# https://llvm.org/docs/CMake.html

CMAKE_OPTS=(
	-DCMAKE_INSTALL_PREFIX="/pkg/main/${PKG}.data.${PVRF}" # use data to avoid addition to PATH

	-C "$S/../clang/cmake/caches/DistributionExample.cmake"

	-DCMAKE_C_FLAGS="${CPPFLAGS} -O2"
	-DCMAKE_CXX_FLAGS="${CPPFLAGS} -O2"
	-DCMAKE_SYSTEM_INCLUDE_PATH="${CMAKE_SYSTEM_INCLUDE_PATH}"
	-DCMAKE_SYSTEM_LIBRARY_PATH="${CMAKE_SYSTEM_LIBRARY_PATH}"

	-DZLIB_LIBRARY=/pkg/main/sys-libs.zlib.libs.${OS}.${ARCH}/lib$LIB_SUFFIX/libz.so
	-DZLIB_INCLUDE_DIR=/pkg/main/sys-libs.zlib.dev.${OS}.${ARCH}/include

	-DLLVM_HOST_TRIPLE="${CHOST}"

	-DLLVM_LIBDIR_SUFFIX=$LIB_SUFFIX

	-DDEFAULT_SYSROOT="/pkg/main/sys-libs.glibc.dev.${OS}.${ARCH}"
	#-DC_INCLUDE_DIRS="/pkg/main/sys-libs.glibc.dev.${OS}.${ARCH}/include"

	-DLIBCXXABI_USE_LLVM_UNWINDER=OFF

	-DPython3_EXECUTABLE=/bin/python3

	# force llvm defaults
	-DCLANG_DEFAULT_CXX_STDLIB="libc++"
	#-DCLANG_DEFAULT_RTLIB="compiler-rt"
	#-DCLANG_DEFAULT_UNWINDLIB="libunwind"
	-DCLANG_CONFIG_FILE_SYSTEM_DIR="/pkg/main/${PKG}.data.${PVRF}/config"

	# ensure DEFAULT_SYSROOT is passed to the subsequent clang
	-DCLANG_BOOTSTRAP_PASSTHROUGH="DEFAULT_SYSROOT;CMAKE_SYSTEM_INCLUDE_PATH;CMAKE_SYSTEM_LIBRARY_PATH;LLVM_HOST_TRIPLE;LLVM_LIBDIR_SUFFIX;ZLIB_LIBRARY;ZLIB_INCLUDE_DIR;LIBCXXABI_USE_LLVM_UNWINDER;CLANG_DEFAULT_CXX_STDLIB;CLANG_DEFAULT_RTLIB;CLANG_DEFAULT_UNWINDLIB;CLANG_CONFIG_FILE_SYSTEM_DIR"
)

# do not use llvmbuild since we are building llvm itself
# do not use docmake either since we want this to be contained in a data dir
cmake -S "${S}" -B "${T}" -G Ninja -Wno-dev "${CMAKE_OPTS[@]}"
ninja -j"$NPROC" -v stage2-distribution || /bin/bash -i

if [ x"$LIB_SUFFIX" != x ]; then
	# pre-create a symlink for lib → lib$LIB_SUFFIX
	mkdir -p "${D}/pkg/main/${PKG}.data.${PVRF}/lib$LIB_SUFFIX"
	ln -snf "lib$LIB_SUFFIX" "${D}/pkg/main/${PKG}.data.${PVRF}/lib"
fi

DESTDIR="${D}" ninja -j"$NPROC" -v stage2-install-distribution

mkdir -p "${D}/pkg/main/${PKG}.data.${PVRF}/config"
echo "@clang-common.cfg" >"${D}/pkg/main/${PKG}.data.${PVRF}/config/clang.cfg"
echo "@clang-common.cfg" >"${D}/pkg/main/${PKG}.data.${PVRF}/config/clang++.cfg"
echo "@clang-cxx.cfg" >>"${D}/pkg/main/${PKG}.data.${PVRF}/config/clang++.cfg"
echo "@clang-common.cfg" >"${D}/pkg/main/${PKG}.data.${PVRF}/config/clang-cpp.cfg"
echo "@clang-cxx.cfg" >>"${D}/pkg/main/${PKG}.data.${PVRF}/config/clang-cpp.cfg"

cat >"${D}/pkg/main/${PKG}.data.${PVRF}/config/clang-common.cfg" <<EOF
--rtlib=compiler-rt
--unwindlib=libgcc
-fuse-ld=bfd
EOF

cat >"${D}/pkg/main/${PKG}.data.${PVRF}/config/clang-cxx.cfg" <<EOF
--stdlib=libc++

# allow finding libc++
-L/pkg/main/${PKG}.data.${PVRF}/lib$LIB_SUFFIX/$TRIPLE/
EOF

fixelf
archive
