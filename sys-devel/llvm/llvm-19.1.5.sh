#!/bin/sh
source "../../common/init.sh"
# this is only the base llvm

inherit llvm

llvmget llvm
acheck

cd "${T}"

importpkg libxml-2.0 icu-uc sci-mathematics/z3 zlib sys-libs/llvm-libunwind sys-libs/libcxx sys-libs/libcxxabi

# importpkg will set CPPFLAGS but that's not read by llvm
export CFLAGS="${CPPFLAGS}"
export CXXFLAGS="${CPPFLAGS}"

CMAKE_OPTS=(
	#-DLLVM_ENABLE_PROJECTS="$LLVM_PROJECTS"
	#-DLLVM_ENABLE_RUNTIMES="$LLVM_RUNTIMES"
	-DLLVM_HOST_TRIPLE="${CHOST}"

	-DLLVM_APPEND_VC_REV=OFF
	-DLLVM_LIBDIR_SUFFIX=$LIB_SUFFIX

	-DLLVM_INCLUDE_TESTS=OFF
	-DLLVM_INCLUDE_BENCHMARKS=OFF
	-DLLVM_BUILD_TESTS=OFF

	# proper way of making llvm a shared lib
	-DLLVM_BUILD_LLVM_DYLIB=ON
	-DLLVM_LINK_LLVM_DYLIB=ON

	# ffi requires extra info to be passed
	-DLLVM_ENABLE_FFI=ON
	-DFFI_INCLUDE_DIR=/pkg/main/dev-libs.libffi.dev/include
	-DFFI_LIBRARY_DIR=/pkg/main/dev-libs.libffi.libs/lib$LIB_SUFFIX

	# enable basic stuff
	-DLLVM_ENABLE_LIBEDIT=ON
	-DLLVM_ENABLE_TERMINFO=ON
	-DLLVM_ENABLE_LIBXML2=ON

	-DLLVM_ENABLE_EH=ON
	-DLLVM_ENABLE_RTTI=ON
	-DLLVM_ENABLE_Z3_SOLVER=ON
	-DLLVM_ENABLE_ZSTD=ON

	-DLLVM_ENABLE_LIBCXX=ON

	# stuff
	-DLLVM_BUILD_DOCS=ON
	-DLLVM_ENABLE_OCAMLDOC=OFF
	-DLLVM_ENABLE_SPHINX=OFF # TODO fix
	-DLLVM_ENABLE_DOXYGEN=OFF
	-DLLVM_INSTALL_UTILS=ON

	-DCMAKE_INSTALL_MANDIR=/pkg/main/${PKG}.doc.${PVRF}/man
	-DLLVM_INSTALL_SPHINX_HTML_DIR=/pkg/main/${PKG}.doc.${PVRF}/html
	-DSPHINX_WARNINGS_AS_ERRORS=OFF
	-DLLVM_ENABLE_THREADS=ON

	-DPython3_EXECUTABLE=python3

	-DLLVM_USE_LINKER=lld
	-DLLVM_ENABLE_LIBCXX=ON

	#-DHAVE_LIBXAR=ON
	-DOCAMLFIND=NO
	#-DLLVM_BUILD_LLVM_DYLIB=ON
	#-DLLVM_LINK_LLVM_DYLIB=ON
)

# do not use llvmbuild since we are biulding llvm itself
docmake "${CMAKE_OPTS[@]}"

# fix dev pkg so bin is available there
mkdir -p "${D}/pkg/main/${PKG}.dev.${PVRF}"
ln -snfTv "/pkg/main/${PKG}.core.${PVRF}/bin" "${D}/pkg/main/${PKG}.dev.${PVRF}/bin"

finalize
