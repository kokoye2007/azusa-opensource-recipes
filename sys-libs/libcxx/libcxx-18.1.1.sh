#!/bin/sh
source "../../common/init.sh"

inherit llvm
llvmget runtimes libcxx libcxxabi

acheck

importpkg sys-libs/llvm-libunwind zlib dev-libs/libffi

export CC=/pkg/main/sys-devel.clang.core/bin/clang
export CXX=/pkg/main/sys-devel.clang.core/bin/clang++

# see http://llvm.org/docs/CMake.html

CMAKE_OPTS=(
	-DLLVM_ENABLE_RUNTIMES="libunwind;libcxxabi;libcxx"

	-DLIBCXXABI_ENABLE_SHARED=ON
	-DLIBCXXABI_ENABLE_STATIC=ON
	-DLIBCXXABI_INCLUDE_TESTS=OFF
	-DLIBCXXABI_USE_LLVM_UNWINDER=ON # setting this to ON means compiling at the same time
	-DLIBCXXABI_ENABLE_STATIC_UNWINDER=ON
	-DLIBCXXABI_USE_COMPILER_RT=ON

	# pass path for libunwind
	-DLIBCXXABI_LIBUNWIND_INCLUDES=/pkg/main/sys-libs.llvm-libunwind.dev.${PV}/include

	-DLIBCXX_LIBDIR_SUFFIX=
	-DLIBCXX_ENABLE_SHARED=ON
	-DLIBCXX_ENABLE_STATIC=ON
	#-DLIBCXX_ENABLE_EXPERIMENTAL_LIBRARY=OFF
	-DLIBCXX_CXX_ABI=libcxxabi
	#-DLIBCXX_CXX_ABI_INCLUDE_PATHS="${WORKDIR}"/libcxxabi/include
	-DLIBCXX_ENABLE_ABI_LINKER_SCRIPT=OFF
	-DLIBCXX_HAS_MUSL_LIBC=OFF # $(usex elibc_musl)
	-DLIBCXX_HAS_GCC_S_LIB=OFF
	-DLIBCXX_INCLUDE_BENCHMARKS=OFF
	-DLIBCXX_INCLUDE_TESTS=OFF
	#-DLIBCXX_TARGET_TRIPLE="${CHOST}"
)

cd "$T"

# build libcxx
CMAKE_TARGET_ALL=cxx CMAKE_TARGET_INSTALL=install-cxx llvmbuild "${CMAKE_OPTS[@]}"

finalize
