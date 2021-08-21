#!/bin/sh
source "../../common/init.sh"

get https://github.com/openjdk/jdk14u/archive/jdk-${PV}-ga.tar.gz

BOOT_JDK="/pkg/main/dev-java.openjdk.core"

# grab tests
cd "${S}"
get http://anduin.linuxfromscratch.org/BLFS/OpenJDK/OpenJDK-${PV}/jtreg-4.2.0-tip.tar.gz
acheck

export CPPFLAGS="${CPPFLAGS} -fno-stack-protector"

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

# fix for gcc10+
sed -i 's/^const char/extern const char/' src/java.base/unix/native/libjava/childproc.h
echo 'const char * const *parentPathv;' >>src/java.base/unix/native/libjava/childproc.c

sed -i 's/^GSS_FUNCTION_TABLE_PTR ftab/extern GSS_FUNCTION_TABLE_PTR ftab/' src/java.security.jgss/share/native/libj2gss/NativeFunc.h
echo 'GSS_FUNCTION_TABLE_PTR ftab;' >>src/java.security.jgss/share/native/libj2gss/NativeFunc.c

make images || /bin/bash -i

#export JT_JAVA=$(echo $PWD/build/*/jdk)
#jtreg/bin/jtreg -jdk:$JT_JAVA -automatic -ignore:quiet -v1 \
#    test/jdk:tier1 test/langtools:tier1
#unset JT_JAVA

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}"
cp -Rv build/*/images/jdk/* "${D}/pkg/main/${PKG}.core.${PVRF}"
#chown -R root:root "${D}/pkg/main/${PKG}.core.${PVRF}"
for s in 16 24 32 48; do
	install -vDm644 src/java.desktop/unix/classes/sun/awt/X11/java-icon${s}.png "${D}/pkg/main/${PKG}.core.${PVRF}/share/icons/hicolor/${s}x${s}/apps/java.png"
done

finalize
