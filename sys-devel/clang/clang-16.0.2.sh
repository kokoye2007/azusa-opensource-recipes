#!/bin/sh
source "../../common/init.sh"

inherit llvm

llvmget clang

acheck

importpkg zlib

cd "${T}"

OPTS=(
	-DLLVM_ENABLE_TERMINFO=ON
	-DLLVM_ENABLE_LIBXML2=ON
	-DLLVM_ENABLE_EH=ON
	-DLLVM_ENABLE_RTTI=ON
	-DLLVM_APPEND_VC_REV=OFF
	-DBUILD_SHARED_LIBS=ON

	-DCLANG_DEFAULT_CXX_STDLIB="libc++"
	-DCLANG_DEFAULT_RTLIB="compiler-rt"
	-DCLANG_DEFAULT_UNWINDLIB="libunwind"
	-DCMAKE_CXX_STANDARD_LIBRARIES="-ldl"

	-DDEFAULT_SYSROOT="/pkg/main/sys-libs.glibc.dev"
	-DC_INCLUDE_DIRS="/pkg/main/sys-libs.glibc.dev.${OS}.${ARCH}/include:/pkg/main/sys-libs.glibc.dev.${OS}.${ARCH}/include/c++/v1"
	#-DCLANG_PYTHON_BINDINGS_VERSIONS=""

	# disable clang plugins because of:
	# /usr/bin/ld: cannot open linker script file /build/clang-16.0.2/temp/lib/Analysis/plugins/SampleAnalyzer/SampleAnalyzerPlugin.exports: No such file or directory
	-DCLANG_PLUGIN_SUPPORT=OFF

	-DCLANG_INCLUDE_TESTS=OFF
)

llvmbuild "${OPTS[@]}" || /bin/bash -i

finalize
