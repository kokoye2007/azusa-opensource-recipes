#!/bin/sh
source "../../common/init.sh"

MY_P="${PN}-${PV/_/-}"

get https://download.sourceforge.net/project/${PN}/${PN}/${PV/_/-}/${MY_P}.tar.bz2
acheck

cd "${S}"

cat >qwtconfig.pri <<-EOF
QWT_INSTALL_LIBS = "/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX"
QWT_INSTALL_HEADERS = "/pkg/main/${PKG}.dev.${PVR}/include/qwt6"
QWT_INSTALL_DOCS = "/pkg/main/${PKG}.doc.${PVR}"
QWT_CONFIG += QwtPlot QwtWidgets QwtPkgConfig
VERSION = ${PV/_*}
QWT_VERSION = ${PV/_*}
QWT_CONFIG += QwtDesigner
QWT_CONFIG += QwtMathML
QWT_CONFIG += QwtOpenGL
QWT_CONFIG += QwtSvg
QWT_CONFIG += qt warn_on thread release no_keywords
QWT_CONFIG += QwtDll

QWT_INSTALL_PLUGINS = "/pkg/main/${PKG}.data.designer.${PVR}"
QWT_INSTALL_FEATURES = "/pkg/main/${PKG}.data.features.${PVR}"
EOF

sed \
	-e 's/target doc/target/' \
	-e "/^TARGET/s:(qwt):(qwt6-qt5):g" \
	-e "/^TARGET/s:qwt):qwt6-qt5):g" \
	-i src/src.pro

sed \
	-e '/qwtAddLibrary/s:(qwt):(qwt6-qt5):g' \
	-e '/qwtAddLibrary/s:qwt):qwt6-qt5):g' \
	-i qwt.prf designer/designer.pro examples/examples.pri \
	textengines/mathml/qwtmathml.prf textengines/textengines.pri

qmake

make
make install INSTALL_ROOT="${D}"

finalize
