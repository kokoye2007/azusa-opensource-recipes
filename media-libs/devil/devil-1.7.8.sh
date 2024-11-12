#!/bin/sh
source "../../common/init.sh"

MY_P=DevIL-${PV}
get https://download.sourceforge.net/openil/"${MY_P}".tar.gz
acheck

cd "$S" || exit
PATCHES=(
	"${FILESDIR}/${P}"-CVE-2009-3994.patch
	"${FILESDIR}/${P}"-libpng14.patch
	"${FILESDIR}/${P}"-nvtt-glut.patch
	"${FILESDIR}/${P}"-ILUT.patch
	"${FILESDIR}/${P}"-restrict.patch
	"${FILESDIR}/${P}"-fix-test.patch
	"${FILESDIR}/${P}"-jasper-remove-uchar.patch
)

apatch "${PATCHES[@]}"

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
