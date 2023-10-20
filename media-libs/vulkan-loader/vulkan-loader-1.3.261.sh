#!/bin/sh
source "../../common/init.sh"

MY_PN=Vulkan-Loader
get https://github.com/KhronosGroup/${MY_PN}/archive/sdk-${PV}.tar.gz ${P}.tar.gz
acheck

cd "${T}"

importpkg X

CMAKEOPTS=(
	-DCMAKE_C_FLAGS="${CFLAGS} -DNDEBUG"
	-DCMAKE_CXX_FLAGS="${CXXFLAGS} -DNDEBUG"
	-DCMAKE_SKIP_RPATH=ON
	-DBUILD_TESTS=OFF
	-DBUILD_WSI_WAYLAND_SUPPORT=ON
	-DBUILD_WSI_XCB_SUPPORT=ON
	-DBUILD_WSI_XLIB_SUPPORT=ON
	-DVULKAN_HEADERS_INSTALL_DIR=/pkg/main/dev-util.vulkan-headers.dev
	-DENABLE_WERROR=OFF
)

docmake "${CMAKEOPTS[@]}"

finalize
