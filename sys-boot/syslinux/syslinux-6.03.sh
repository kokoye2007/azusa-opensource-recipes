#!/bin/sh
source "../../common/init.sh"

get https://mirrors.edge.kernel.org/pub/linux/utils/boot/${PN}/${P}.tar.gz
acheck

cd "${P}"
patch -p1 <"$FILESDIR/syslinux-6.03-sysmacros.patch"

# make sure makefiles won't override ldflags
#sed -i extlinux/Makefile linux/Makefile mtools/Makefile sample/Makefile utils/Makefile -e '/^LDFLAGS/d'
#sed -i extlinux/Makefile linux/Makefile mtools/Makefile sample/Makefile utils/Makefile -e 's|CFLAGS[[:space:]]+=|CFLAGS +=|g'

importpkg sys-apps/util-linux

make bios efi32 efi64 installer install \
	CC="gcc $CPPFLAGS $LDFLAGS" \
	INSTALLROOT="${D}" \
	BINDIR="/pkg/main/${PKG}.core.${PVR}/bin" \
	SBINDIR="/pkg/main/${PKG}.core.${PVR}/sbin" \
	LIBDIR="/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX" \
	DATADIR="/pkg/main/${PKG}.core.${PVR}/share" \
	MANDIR="/pkg/main/${PKG}.doc.${PVR}/man" \
	INCDIR="/pkg/main/${PKG}.dev.${PVR}/include" \
	TFTPBOOT="/pkg/main/${PKG}.core.${PVR}/tftpboot"

finalize
