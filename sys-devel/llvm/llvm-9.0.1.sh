#!/bin/sh
source "../../common/init.sh"

get https://github.com/llvm/llvm-project/releases/download/llvmorg-${PV}/${P}.src.tar.xz
acheck

cd "${T}"

importpkg libxml-2.0 icu-uc
# importpkg will set CPPFLAGS but that's not read by llvm
export CFLAGS="${CPPFLAGS}"
export CXXFLAGS="${CPPFLAGS}"

CMAKE_OPTS=(
	-DLLVM_APPEND_VC_REV=OFF
	-DLLVM_LIBDIR_SUFFIX=$LIB_SUFFIX

	-DBUILD_SHARED_LIBS=ON

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

	-DWITH_POLLY=OFF

	# stuff
	-DLLVM_BUILD_DOCS=ON
	-DLLVM_ENABLE_OCAMLDOC=OFF
	-DLLVM_ENABLE_SPHINX=OFF # TODO fix
	-DLLVM_ENABLE_DOXYGEN=OFF
	-DLLVM_INSTALL_UTILS=ON

	-DCMAKE_INSTALL_MANDIR=/pkg/main/${PKG}.doc.${PVR}/man
	-DLLVM_INSTALL_SPHINX_HTML_DIR=/pkg/main/${PKG}.doc.${PVR}/html
	-DSPHINX_WARNINGS_AS_ERRORS=OFF
	-DLLVM_ENABLE_THREADS=ON

	-DLLVM_USE_LINKER=gold
	-DLLVM_ENABLE_LIBCXX=ON

	#-DHAVE_LIBXAR=ON
	-DOCAMLFIND=NO
	#-DLLVM_BUILD_LLVM_DYLIB=ON
	#-DLLVM_LINK_LLVM_DYLIB=ON

)

# see http://llvm.org/docs/CMake.html
CMAKE_ROOT="${CHPATH}/${P}.src"

docmake "${CMAKE_OPTS[@]}"

make -j8
make install DESTDIR="${D}"

#cmake -DCMAKE_INSTALL_PREFIX="${D}/pkg/main/${PKG}.core.${PVR}" -P cmake_install.cmake

# fix dev pkg so bin is available there
mkdir -p "${D}/pkg/main/${PKG}.dev.${PVR}"
ln -snfTv "/pkg/main/${PKG}.core.${PVR}/bin" "${D}/pkg/main/${PKG}.dev.${PVR}/bin"

finalize
