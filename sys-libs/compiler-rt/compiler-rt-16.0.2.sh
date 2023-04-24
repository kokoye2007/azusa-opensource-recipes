#!/bin/sh
source "../../common/init.sh"

inherit llvm
get https://github.com/llvm/llvm-project/releases/download/llvmorg-${PV}/${P}.src.tar.xz
acheck

cd "${T}"

importpkg zlib dev-libs/libffi

# see http://llvm.org/docs/CMake.html

CMAKE_OPTS=(
	-DCOMPILER_RT_INSTALL_PATH="/pkg/main/${PKG}.core.${PVRF}"
	-DCOMPILER_RT_INCLUDE_TESTS=OFF
	-DCOMPILER_RT_BUILD_LIBFUZZER=OFF
	-DCOMPILER_RT_BUILD_MEMPROF=OFF
	-DCOMPILER_RT_BUILD_ORC=OFF
	-DCOMPILER_RT_BUILD_PROFILE=OFF
	-DCOMPILER_RT_BUILD_SANITIZERS=OFF
	-DCOMPILER_RT_BUILD_XRAY=OFF

	-DPython3_EXECUTABLE="/bin/python3"
)

case "$ARCH" in
	amd64)
		CMAKE_OPTS+=(
			#-DCAN_TARGET_i386=ON
			-DCAN_TARGET_x86_64=ON
		)
		;;
esac

docmake "${CMAKE_OPTS[@]}"

finalize
