#!/bin/sh
source "../../common/init.sh"
# options:
# clang clang-tools-extra compiler-rt libc libclc libcxx libcxxabi libunwind lld lldb mlir openmp parallel-libs polly pstl flang
# libunwind requires being built in a monorepo layout with libcxx available
# no idea where to download "libc" from
#LLVM_RUNTIMES="compiler-rt;libcxx;libcxxabi;libunwind;openmp"
LLVM_RUNTIMES="compiler-rt;libcxx;libcxxabi;libunwind"

get https://github.com/llvm/llvm-project/releases/download/llvmorg-${PV}/${P}.src.tar.xz
OIFS="$IFS"
IFS="; "
for project in $LLVM_RUNTIMES; do
	get https://github.com/llvm/llvm-project/releases/download/llvmorg-${PV}/${project}-${PV}.src.tar.xz
	mv "${project}-${PV}.src" "${project}"
done
IFS="$OIFS"

acheck

cd "${T}"

importpkg libxml-2.0 icu-uc sci-mathematics/z3 zlib
# importpkg will set CPPFLAGS but that's not read by llvm
export CFLAGS="${CPPFLAGS}"
export CXXFLAGS="${CPPFLAGS}"

CMAKE_OPTS=(
	-DLLVM_ENABLE_PROJECTS="$LLVM_RUNTIMES"
	#-DLLVM_ENABLE_RUNTIMES="$LLVM_RUNTIMES" # ain't working right 
	-DLLVM_HOST_TRIPLE="${CHOST}"

	-DLLVM_APPEND_VC_REV=OFF
	-DLLVM_LIBDIR_SUFFIX=$LIB_SUFFIX

	-DBUILD_SHARED_LIBS=ON
	-DLLVM_INCLUDE_TESTS=OFF
	-DLLVM_INCLUDE_BENCHMARKS=OFF

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

	-DLLVM_USE_LINKER=gold
	-DLLVM_ENABLE_LIBCXX=ON

	#-DHAVE_LIBXAR=ON
	-DOCAMLFIND=NO
	#-DLLVM_BUILD_LLVM_DYLIB=ON
	#-DLLVM_LINK_LLVM_DYLIB=ON

	-DLIBCXX_INCLUDE_BENCHMARKS=OFF
)

# see http://llvm.org/docs/CMake.html
CMAKE_ROOT="${CHPATH}/${P}.src"

docmake "${CMAKE_OPTS[@]}"

# fix dev pkg so bin is available there
mkdir -p "${D}/pkg/main/${PKG}.dev.${PVRF}"
ln -snfTv "/pkg/main/${PKG}.core.${PVRF}/bin" "${D}/pkg/main/${PKG}.dev.${PVRF}/bin"

finalize
