#!/bin/sh

# ensure we have the right version of llvm-config in path first
export PATH="/pkg/main/sys-devel.llvm.core.${PV}/bin:$PATH"

llvmgetfull() {
	CATEGORY=sys-devel PN=llvm get https://github.com/llvm/llvm-project/releases/download/llvmorg-${PV}/llvm-project-${PV}.src.tar.xz
}

llvmget() {
	case "$1" in
		"")
			llvmgetfull
			;;
		_*)
			# get full
			llvmgetfull
			S="$S/${1/_/}"
			;;
		runtimes)
			llvmgetfull
			S="$S/$1"
			;;
		*)
			for sub in "$@"; do
				if [ x"$S" = x ]; then
					S="$WORKDIR/$sub"
				fi
				get https://github.com/llvm/llvm-project/releases/download/llvmorg-${PV}/${sub}-${PV}.src.tar.xz
				mv -v "${sub}-${PV}.src" "$sub"
			done
			# enable llvm cmake
			ln -snfv "/pkg/main/sys-devel.llvm-cmake.src.${PV}.any.any/cmake" "$WORKDIR/cmake"
			;;
	esac
}

llvmbuild() {
	local LLVM_OPTS=(
		-DLLVM_INCLUDE_TESTS=OFF
		-DLLVM_LIBDIR_SUFFIX=${LIB_SUFFIX}

		-DLLVM_DIR=/pkg/main/sys-devel.llvm.dev.${PV}/lib$LIB_SUFFIX/cmake/llvm
		-DClang_DIR=/pkg/main/sys-devel.clang.dev.${PV}/lib$LIB_SUFFIX/cmake/clang

		-DLLVM_ENABLE_FFI=ON -DFFI_INCLUDE_DIR=/pkg/main/dev-libs.libffi.dev/include -DFFI_LIBRARY_DIR=/pkg/main/dev-libs.libffi.libs/lib$LIB_SUFFIX
	)

	docmake "${LLVM_OPTS[@]}" "$@"
}
