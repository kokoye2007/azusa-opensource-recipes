#/bin/sh
source "../../common/init.sh"

get http://zlib.net/${P}.tar.gz

if [ ! -d ${P} ]; then
	echo "Extracting ${P} ..."
	tar xf ${P}.tar.gz
fi

echo "Compiling ${P} ..."
cd "${T}"

# configure & build
${CHPATH}/${P}/configure >configure.log 2>&1 --prefix=/pkg/main/${PKG}.dev.${PVR} --libdir=/pkg/main/${PKG}.libs.${PVR}/lib
make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install DESTDIR=${D}

cd "${D}"
mkdir -p "pkg/main/${PKG}.doc.${PVR}"
mv "pkg/main/${PKG}.dev.${PVR}/share/man" "pkg/main/${PKG}.doc.${PVR}"
rmdir "pkg/main/${PKG}.dev.${PVR}/share"

finalize
cleanup
