#!/bin/sh
source "../../common/init.sh"

get https://github.com/llvm/llvm-project/releases/download/llvmorg-${PV}/${P}.src.tar.xz
acheck

cd "${T}"

# see http://llvm.org/docs/CMake.html

# make it possible to run llvm tools within a non-azusa linux (TEMP)
export LLVM_DIR=/pkg/main/sys-devel.llvm.dev.${PV}/lib64/cmake/llvm

CMAKE_ROOT="${CHPATH}/${P}.src"

CMAKE_OPTS=(
	-DCOMPILER_RT_INSTALL_PATH="/pkg/main/${PKG}.core.${PVRF}"
	-DCOMPILER_RT_INCLUDE_TESTS=OFF
	-DCOMPILER_RT_BUILD_LIBFUZZER=OFF
	-DCOMPILER_RT_BUILD_MEMPROF=OFF
	-DCOMPILER_RT_BUILD_ORC=OFF
	-DCOMPILER_RT_BUILD_PROFILE=OFF
	-DCOMPILER_RT_BUILD_SANITIZERS=OFF
	-DCOMPILER_RT_BUILD_XRAY=OFF

	-DPython3_EXECUTABLE="/bin/python"
)

case "$ARCH" in
	amd64)
		CMAKE_OPTS+=(
			-DCAN_TARGET_i386=ON
			-DCAN_TARGET_x86_64=ON
		)
		;;
esac

docmake "${CMAKE_OPTS[@]}"

finalize
