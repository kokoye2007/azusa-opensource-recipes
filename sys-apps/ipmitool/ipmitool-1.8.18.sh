#!/bin/sh
source "../../common/init.sh"

COMMIT_ID=7fd7c0f2ba39e223868a8d83d81d4074f057d6fc
get https://github.com/ipmitool/ipmitool/archive/${COMMIT_ID}.tar.gz

#get https://github.com/ipmitool/ipmitool/releases/download/IPMITOOL_1_8_18/${P}.tar.bz2
get https://dev.gentoo.org/~robbat2/distfiles/ipmitool_1.8.18-9.debian-ported-gentoo.tar.xz

# https://www.iana.org/assignments/enterprise-numbers/enterprise-numbers
# is not available with version numbers or dates!
get https://dev.gentoo.org/~robbat2/distfiles/enterprise-numbers.2020-10-21.xz
acheck

cd "${S}"

if [ -d "${S}"/debian ] ; then
	mv "${S}"/debian{,.package}
	ln -s "${WORKDIR}"/debian "${S}"
	# Upstream commit includes SOME of the debian changes, but not all of them
	sed -i \
		-e '/^#/d' \
		-e '/0120-openssl1.1.patch/d' \
		debian/patches/series
	for p in $(cat debian/patches/series) ; do
		echo ${p}
		apatch debian/patches/${p}
	done
fi
	

pd="${WORKDIR}"/ipmitool_1.8.18-9.debian-ported-gentoo/
PATCHES=(
	#"${pd}"/0000.0120-openssl1.1.patch
	"${pd}"/0001.0100-fix_buf_overflow.patch
	"${pd}"/0002.0500-fix_CVE-2011-4339.patch
	"${pd}"/0003.0600-manpage_longlines.patch
	#"${pd}"/0004.0110-getpass-prototype.patch
	#"${pd}"/0005.0115-typo.patch
	"${pd}"/0006.0125-nvidia-iana.patch
	"${pd}"/0007.0615-manpage_typo.patch
	#"${pd}"/0008.0130-Correct_lanplus_segment_violation.patch
	"${pd}"/0009.0005-gcc10.patch
	#"${pd}"/0010.0010-utf8.patch
)

apatch "${PATCHES[@]}"

aautoreconf

# If this file is not present, then ipmitool will try to download it during make install!
cp -al "${WORKDIR}/enterprise-numbers.2020-10-21" "${S}"/enterprise-numbers

cd "${T}"

importpkg tinfo sys-libs/readline openssl sys-libs/freeipmi

doconf --enable-intf-lan --enable-intf-usb --enable-intf-lanplus --enable-intf-serial --with-kerneldir=/pkg/main/sys-kernel.linux.dev --enable-intf-free --enable-intf-open --enable-intf-imb --enable-ipmishell --enable-file-security

make
make install DESTDIR="${D}"

finalize
