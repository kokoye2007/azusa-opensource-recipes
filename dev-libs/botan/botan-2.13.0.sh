#!/bin/sh
source "../../common/init.sh"

get https://botan.randombit.net/releases/Botan-${PV}.tar.xz
acheck

cd "Botan-${PV}"

importpkg openssl zlib app-arch/bzip2 sqlite3 liblzma dev-libs/boost

python3 configure.py \
	--extra-cxxflags="${CPPFLAGS}" --ldflags="${LDFLAGS}" \
	--system-cert-bundle=/etc/ssl/certs/ca-certificates.crt --with-openmp --with-python-versions=3.8 --with-boost --with-bzip2 --with-lzma --with-openssl --with-commoncrypto --with-sqlite3 --with-zlib --prefix=/pkg/main/${PKG}.core.${PVR} --libdir=/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX --includedir=/pkg/main/${PKG}.dev.${PVR}/include

make
make install DESTDIR="${D}"

finalize
