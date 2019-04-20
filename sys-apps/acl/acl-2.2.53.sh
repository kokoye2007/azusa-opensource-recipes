#!/bin/sh
source "../../common/init.sh"

get http://download.savannah.nongnu.org/releases/acl/${P}.tar.gz

if [ ! -d ${P} ]; then
	echo "Extracting ${P} ..."
	tar xf ${P}.tar.gz
fi

echo "Compiling ${P} ..."
cd "${T}"

# configure & build
${CHPATH}/${P}/configure >configure.log 2>&1 --prefix=/usr --sysconfdir=/etc --exec-prefix=/pkg/main/${PKG}.core.${ACL_VER} \
--includedir=/pkg/main/${PKG}.dev.${ACL_VER}/include --libdir=/pkg/main/${PKG}.libs.${ACL_VER}/lib --datarootdir=/pkg/main/${PKG}.core.${ACL_VER} \
--mandir=/pkg/main/${PKG}.doc.${ACL_VER}/man --docdir=/pkg/main/${PKG}.doc.${ACL_VER}/doc

make >make.log 2>&1
make >make_install.log 2>&1 install DESTDIR="${D}"

finalize
cleanup
