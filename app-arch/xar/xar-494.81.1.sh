#!/bin/sh
source "../../common/init.sh"

get https://github.com/apple-oss-distributions/xar/archive/refs/tags/"${P}".tar.gz
acheck

importpkg libxml-2.0 zlib app-arch/bzip2 dev-libs/openssl

S="${S}/xar"

cd "$S" || exit

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.1-ext2.patch
	"${FILESDIR}"/${PN}-1.8-safe_dirname.patch
	"${FILESDIR}"/${PN}-1.8-arm-ppc.patch
	"${FILESDIR}"/${PN}-1.8-openssl-1.1.patch
	"${FILESDIR}"/${PN}-1.8.0.0.452-linux.patch
	"${FILESDIR}"/${PN}-1.8.0.0.487-non-darwin.patch
	"${FILESDIR}"/${PN}-1.8.0.0.487-variable-sized-object.patch
)

apatch "${PATCHES[@]}"

autoconf

sed -i -e 's/@RPATH@//' src/Makefile.inc.in
echo ".PRECIOUS: @objroot@src/%.o" >> src/Makefile.inc.in

cd "${S}"/include || die
mv ../lib/*.h . || die

cd "${T}" || exit

export LIBS="$(pkg-config --libs openssl)"

doconf --disable-static

( cd include && ln -s . xar )

make
make install DESTDIR="${D}"

finalize
