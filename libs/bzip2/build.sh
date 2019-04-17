#/bin/sh
set -e

BZIP2_VER=1.0.6
ARCH=`uname -m`
OS=`uname -s | tr A-Z a-z`

case $ARCH in
	x86_64)
		ARCH=amd64
		;;
esac

# fetch bzip2, compile, build
if [ ! -f bzip2-${BZIP2_VER}.tar.gz ]; then
	wget https://sourceware.org/pub/bzip2/bzip2-${BZIP2_VER}.tar.gz
fi

if [ ! -d bzip2-${BZIP2_VER} ]; then
	echo "Extracting bzip2-${BZIP2_VER} ..."
	tar xf bzip2-${BZIP2_VER}.tar.gz
fi

echo "Compiling bzip2-${BZIP2_VER} ..."
cd bzip2-${BZIP2_VER}
make distclean >make_distclean.log 2>&1

# configure & build
make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install PREFIX=../dist/work

cd ..


echo "Building squashfs..."

# build squashfs files
# dist/pkg/by-name/core.bzip2.${BZIP2_VER} (bin, man)
# dist/pkg/by-name/dev.bzip2.${BZIP2_VER} (include, lib)

mkdir -p dist/pkg/by-name/
rsync -a dist/work/bin dist/work/man dist/pkg/by-name/core.bzip2.${BZIP2_VER}/
rsync -a dist/work/include dist/work/lib dist/pkg/by-name/dev.bzip2.${BZIP2_VER}/

mksquashfs "dist/pkg/by-name/dev.bzip2.${BZIP2_VER}" "dist/dev.bzip2.${BZIP2_VER}.${OS}.${ARCH}.squashfs" -all-root -b 4096
mksquashfs "dist/pkg/by-name/core.bzip2.${BZIP2_VER}" "dist/core.bzip2.${BZIP2_VER}.${OS}.${ARCH}.squashfs" -all-root -b 4096

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
