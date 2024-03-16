#!/bin/sh
source ../../common/init.sh
inherit python

cat > "${T}"/mplsetup.cfg <<- EOF
	[directories]
	basedirlist = ${EPREFIX}/usr
	[provide_packages]
	pytz = False
	dateutil = False
	[libs]
	system_freetype = True
	system_qhull = True
	[packages]
	tests = False
	[gui_support]
	agg = True
	gtk = False
	gtkagg = False
	macosx = False
	pyside = False
	pysideagg = False
	qt4 = False
	qt4agg = False
	gtk3 = True
	gtk3agg = True
	cairo = True
	cairoagg = True
	qt5 = False
	qt5agg = False
	tk = False
	tgagg = False
	wx = False
	wxagg = False
EOF
# todo: qt5 tk wxwidgets

export MPLSETUPCFG="${T}/mplsetup.cfg"

importpkg media-libs/qhull

python_do_standard_package
