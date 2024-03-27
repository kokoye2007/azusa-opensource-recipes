#!/bin/sh
source "../../common/init.sh"
inherit python

get https://gitlab.gnome.org/GNOME/libxml2/-/archive/v${PV}/libxml2-v${PV}.tar.bz2
acheck

cd "${S}"

aautoreconf

# can't run in T because of python
#cd "${T}"

importpkg python-${PYTHON_LATEST%.*} icu-uc sys-libs/libxcrypt

doconf --disable-maintainer-mode --disable-static --with-icu

make
make install DESTDIR="${D}"

# fix for ffmpeg (and probably others)
ln -v -s . "${D}/pkg/main/${PKG}.dev.${PVRF}/include/libxml2/libxml2"

organize

# run python
cd "${S}/python"

# fix includes_dir to include both ${D}/pkg/main/${PKG}.dev.${PVRF}/include and /pkg/main/sys-libs.glibc.dev/include
sed -i -e "s#^includes_dir = \\[#includes_dir = ['${D}/pkg/main/${PKG}.dev.${PVRF}/include', '/pkg/main/sys-libs.glibc.dev/include',#" setup.py
export LDFLAGS="${LDFLAGS} -L${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"

pythonsetup

# because we use icu with libxml2, we need to add the include path to icu in cflags, or dependencies will not build
ICU_PATH=`realpath /pkg/main/dev-libs.icu.dev/include`
echo "Adding ICU path $ICU_PATH"
echo " -> fixing libxml-2.0.pc"
sed -i -re "s#^Cflags:(.*)#Cflags:\\1 -I${ICU_PATH}#" "${D}/pkg/main/${PKG}.dev.${PVRF}/pkgconfig/libxml-2.0.pc"
echo " -> fixing libxml2-config.cmake"
sed -i -re "s#^set\\(LIBXML2_INCLUDE_DIRS(.*)\\)#set(LIBXML2_INCLUDE_DIRS\\1 ${ICU_PATH})#" "${D}/pkg/main/${PKG}.dev.${PVRF}/cmake/libxml2/libxml2-config.cmake"

fixelf
archive
