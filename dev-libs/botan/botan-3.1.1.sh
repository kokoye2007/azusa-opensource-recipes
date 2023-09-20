#!/bin/sh
source "../../common/init.sh"
inherit python

get https://botan.randombit.net/releases/Botan-${PV}.tar.xz
acheck

cd "Botan-${PV}"

importpkg zlib app-arch/bzip2 sqlite3 liblzma dev-libs/boost

python3 configure.py \
	--extra-cxxflags="${CPPFLAGS}" --ldflags="${LDFLAGS}" \
	--system-cert-bundle=/etc/ssl/certs/ca-certificates.crt --with-python-versions=${PYTHON_LATEST%.*} --with-boost --with-bzip2 --with-lzma --with-commoncrypto --with-sqlite3 --with-zlib --prefix=/pkg/main/${PKG}.core.${PVRF} --libdir=/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX --includedir=/pkg/main/${PKG}.dev.${PVRF}/include

make -j"$NPROC"
make install DESTDIR="${D}"

finalize
