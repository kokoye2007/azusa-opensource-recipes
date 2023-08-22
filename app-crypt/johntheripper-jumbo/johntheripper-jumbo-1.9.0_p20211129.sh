#!/bin/sh
source "../../common/init.sh"

HASH_COMMIT="5d0c85f16f96ca7b6dd06640e95a5801081d6e20"
get https://github.com/openwall/john/archive/${HASH_COMMIT}.tar.gz "$P.tar.gz"
acheck

cd "${S}/src"

importpkg sys-cluster/openmpi dev-libs/openssl net-libs/libpcap dev-libs/gmp zlib sys-libs/libxcrypt app-arch/bzip2 dev-util/opencl-headers dev-util/nvidia-cuda-toolkit

doconf --enable-pkg-config --disable-native-march --disable-native-tests --disable-rexgen --with-openssl --with-systemwide --enable-mpi --enable-opencl --enable-openmp --enable-pcap

make

cd "${S}"

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/sbin"
# pax-mark -mr "${ED}/usr/sbin/john"
cp -v run/john "${D}/pkg/main/${PKG}.core.${PVRF}/sbin"
cp -v run/mailer "${D}/pkg/main/${PKG}.core.${PVRF}/sbin/john-mailer"

for s in \
	unshadow unafs undrop unique ssh2john putty2john pfx2john keepass2john keyring2john \
	zip2john gpg2john rar2john racf2john keychain2john kwallet2john pwsafe2john dmg2john \
	hccap2john base64conv truecrypt_volume2john keystore2john
do
	ln -snf john "${D}/pkg/main/${PKG}.core.${PVRF}/sbin/$s"
done

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/share"
cp -vr run/*.pl run/*.py run/lib "${D}/pkg/main/${PKG}.core.${PVRF}/share"

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/etc"
cp -vr run/*.chr run/password.lst run/*.conf run/rules run/ztex "${D}/pkg/main/${PKG}.core.${PVRF}/etc"

mkdir -p "${D}/pkg/main/${PKG}.doc.${PVRF}/doc"
cp -vr README.md doc/* "${D}/pkg/main/${PKG}.doc.${PVRF}/doc"

finalize
