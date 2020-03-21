#/bin/sh
source "../../common/init.sh"

get https://sourceware.org/pub/bzip2/${P}.tar.gz

echo "Compiling ${P} ..."
cd ${P}

patch -p1 <"$FILESDIR/bzip2-1.0.6-saneso.patch"

# relative symlinks
sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile

# configure & build
make -f Makefile-libbz2_so
make clean
make

# install
mkdir -p ${D}/work
make install PREFIX="${D}/work"

mkdir -p $D/pkg/main/${PKG}.{libs,core,dev,doc}.${PVRF}

# shared libs
mkdir $D/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX
cp -a libbz2.so* $D/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX

# extra lib symlinks
ln -snf libbz2.so.1.0.6 "$D/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX/libbz2.so"
ln -snf libbz2.so.1.0.6 "$D/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX/libbz2.so.1"

# copy stuff
cd $D
mv work/bin pkg/main/${PKG}.core.${PVRF}/
mv work/man pkg/main/${PKG}.doc.${PVRF}/
mv work/include pkg/main/${PKG}.dev.${PVRF}/

archive
