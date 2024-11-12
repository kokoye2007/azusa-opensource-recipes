#!/bin/sh
source "../../common/init.sh"

get http://www.mr511.de/software/"${P}".tar.gz
cd "${S}" || exit
apatch "$FILESDIR/libelf-0.8.13-build.patch"
aautoreconf
acheck

cd "${T}" || exit

# prefix might want to play with this; unfortunately the stupid
# macro used to detect whether we're building ELF is so screwed up
# that trying to fix it is just a waste of time.
export mr_cv_target_elf=yes

doconflight --enable-shared --enable-nls

make
make prefix="${D}/pkg/main/${PKG}.core.${PVRF}" libdir="${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX" install install-compat -j1

# rename the .pc file to avoid clashing with elfutils
mv -v "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX/pkgconfig/libelf.pc" "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX/pkgconfig/libelf-legacy.pc"

finalize
