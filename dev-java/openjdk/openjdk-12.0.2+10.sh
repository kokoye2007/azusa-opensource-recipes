#!/bin/sh
source "../../common/init.sh"

get http://hg.openjdk.java.net/jdk-updates/jdk12u/archive/jdk-${PV}.tar.bz2

BOOT_JDK="/pkg/main/dev-java.openjdk.core"

if [ ! -d "$BOOT_JDK" ]; then
	# grab LFS bootjdk
	cd "${T}"
	get https://download.java.net/java/GA/jdk12.0.2/e482c34c86bd4bf8b56c0b35558996b9/10/GPL/openjdk-12.0.2_linux-x64_bin.tar.gz
	BOOT_JDK="${T}/jdk-12.0.2"
fi

# grab tests
cd "${CHPATH}/jdk12u-jdk-${PV}"
get http://anduin.linuxfromscratch.org/BLFS/OpenJDK/OpenJDK-12.0.2/jtreg-4.2-b13-517.tar.gz

acheck

unset JAVA_HOME
importpkg x11 libjpeg media-libs/giflib zlib lcms2

bash configure --enable-unlimited-crypto \
	--disable-warnings-as-errors \
	--with-stdc++lib=dynamic \
	--with-giflib=system \
	--with-jtreg=$PWD/jtreg \
	--with-lcms=system \
	--with-libjpeg=system \
	--with-libpng=system \
	--with-zlib=system \
	--with-version-build="10" \
	--with-version-pre="" \
	--with-version-opt="" \
	--with-boot-jdk="$BOOT_JDK" \
	--x-includes="/pkg/main/azusa.symlinks.core/full/include" \
	--x-libraries="/pkg/main/azusa.symlinks.core/full/lib$LIB_SUFFIX" \
	--with-cups-include="/pkg/main/net-print.cups.dev/include" \
	--with-fontconfig-include="/pkg/main/media-libs.fontconfig.dev/include" \
	--with-extra-cflags="$CPPFLAGS" --with-extra-cxxflags="$CPPFLAGS" --with-extra-ldflags="$LDFLAGS"
#	--x-includes="/pkg/main/x11-libs.libX11.dev/include"
#	--x-libraries="/pkg/main/x11-libs.libX11.dev/lib$LIB_SUFFIX"
#	--with-cacerts-file=/etc/pki/tls/java/cacerts

make images

#export JT_JAVA=$(echo $PWD/build/*/jdk)
#jtreg/bin/jtreg -jdk:$JT_JAVA -automatic -ignore:quiet -v1 \
#    test/jdk:tier1 test/langtools:tier1
#unset JT_JAVA

mkdir -p "${D}/pkg/main/${PKG}.core.${PVR}"
cp -Rv build/*/images/jdk/* "${D}/pkg/main/${PKG}.core.${PVR}"
#chown -R root:root "${D}/pkg/main/${PKG}.core.${PVR}"
for s in 16 24 32 48; do
	install -vDm644 src/java.desktop/unix/classes/sun/awt/X11/java-icon${s}.png "${D}/pkg/main/${PKG}.core.${PVR}/share/icons/hicolor/${s}x${s}/apps/java.png"
done

finalize
