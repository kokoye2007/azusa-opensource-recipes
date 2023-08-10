#!/bin/sh
source "../../common/init.sh"

get https://github.com/Cisco-Talos/clamav/archive/refs/tags/${P}.tar.gz
#acheck
envcheck # clamav requires network access to build because of rust

importpkg zlib app-arch/bzip2 dev-libs/libpcre2 dev-libs/libmspack

cd "${T}"

OPTS=(
	-DAPP_CONFIG_DIRECTORY=/etc/clamav
	-DBYTECODE_RUNTIME=interpreter # llvm
	-DCLAMAV_GROUP=clamav
	-DCLAMAV_USER=clamav
	-DDATABASE_DIRECTORY=/var/lib/clamav
	-DENABLE_APP=ON
	-DENABLE_CLAMONACC=ON
	-DENABLE_DOXYGEN=ON
	-DENABLE_EXPERIMENTAL=OFF
	-DENABLE_EXTERNAL_MSPACK=ON
	-DENABLE_JSON_SHARED=ON
	-DENABLE_MAN_PAGES=ON
	-DENABLE_MILTER=OFF
	-DENABLE_SHARED_LIB=ON
	-DENABLE_STATIC_LIB=OFF
	-DENABLE_SYSTEMD=OFF
	-DENABLE_TESTS=OFF
	-DENABLE_UNRAR=ON
	-DOPTIMIZE=ON

	#-DLLVM_ROOT_DIR=
	#-DLLVM_FIND_VERSION=
)

docmake "${OPTS[@]}"

finalize
