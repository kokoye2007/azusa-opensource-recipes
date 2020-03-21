#!/bin/sh
source "../../common/init.sh"

get ftp://tug.org/texlive/historic/${PV:0:4}/texlive-${PV}-source.tar.xz
acheck

cd "texlive-${PV}-source"

mkdir texlive-build
cd texlive-build

TEXMF="/pkg/main/app-text.texlive-texmf.misc.${PV}/"

importpkg zlib libpng gmp mpfr icu-uc app-text/libpaper x11-base/xorg-proto x11-libs/libX11 x11-libs/libXext x11-libs/libXaw

CONFIGURE=(
	--disable-native-texlive-build
	--disable-static
	--enable-shared
	--disable-dvisvgm
	--infodir="$TEXMF/texmf-dist/doc/info"
	--mandir="$TEXMF/texmf-dist/doc/man"
	--with-system-cairo
	--with-system-fontconfig
	--with-system-freetype2
	--with-system-gmp
	--with-system-graphite2
	--with-system-harfbuzz
	--with-system-icu
	--with-system-libgs
	--with-system-libpaper
	--with-system-libpng
	--with-system-mpfr
	--with-system-pixman
	--with-system-zlib
	--with-banner-add=" - AZUSA"
)

doconf "${CONFIGURE[@]}" || /bin/bash -i

make
make install-strip DESTDIR="${D}"
if [ -f /bin/pdflatex ]; then
	make texlinks
	mkdir -pv "${D}/pkg/main/${PKG}.doc.${PVRF}/tlpkg/TeXLive/"
	install -v -m644 ../texk/tests/TeXLive/* "${D}/pkg/main/${PKG}.doc.${PVRF}/tlpkg/TeXLive/"

	if [ -d "$TEXMF" ]; then
		# ??
		mktexlsr
		fmtutil-sys --all
		mtxrun --generate
	fi
fi

finalize
