#/bin/sh
source "../../common/init.sh"

get https://sourceware.org/pub/bzip2/${P}.tar.gz

if [ ! -d ${P} ]; then
	echo "Extracting ${P} ..."
	tar xf ${P}.tar.gz
fi

echo "Compiling ${P} ..."
cd ${P}
make distclean >make_distclean.log 2>&1

# relative symlinks
sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile

# configure & build
make >make.log 2>&1 -f Makefile-libbz2_so
make >>make.log 2>&1 clean
make >>make.log 2>&1

# install
mkdir -p ${D}/work
make >make_install.log 2>&1 install PREFIX="${D}/work"

mkdir -p $D/pkg/main/${PKG}.{libs,core,dev,doc}.${PVR}

# shared libs
mkdir $D/pkg/main/${PKG}.libs.${PVR}/lib
cp -a libbz2.so* $D/pkg/main/${PKG}.libs.${PVR}/lib

# copy stuff
cd $D
mv work/bin pkg/main/${PKG}.core.${PVR}/
mv work/man pkg/main/${PKG}.doc.${PVR}/
mv work/include pkg/main/${PKG}.dev.${PVR}/

finalize
cleanup
