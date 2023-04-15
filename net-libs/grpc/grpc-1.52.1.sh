#!/bin/sh
source "../../common/init.sh"

get https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz ${P}.tar.gz
acheck

# suppress network access, package builds fine without the submodules
mkdir "${S}/third_party/opencensus-proto/src" || die

cd "${T}"

importpkg net-dns/c-ares dev-libs/protobuf zlib dev-cpp/abseil-cpp

CMAKEARGS=(
	-DgRPC_INSTALL=ON
	-DgRPC_ABSL_PROVIDER=package
	-DgRPC_BACKWARDS_COMPATIBILITY_MODE=OFF
	-DgRPC_CARES_PROVIDER=package
	-DgRPC_PROTOBUF_PROVIDER=package
	-DgRPC_RE2_PROVIDER=package
	-DgRPC_SSL_PROVIDER=package
	-DgRPC_ZLIB_PROVIDER=package
	-DgRPC_BUILD_TESTS=OFF
	-DCMAKE_CXX_STANDARD=17
)

docmake "${CMAKEARGS[@]}"

finalize
