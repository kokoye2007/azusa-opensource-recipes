#!/bin/sh
source "../../common/init.sh"

MY_PN=acpica-unix
MY_P="${MY_PN}-${PV}"
get http://www.acpica.org/sites/acpica/files/"${MY_P}".tar.gz
cd "${S}" || exit
apatch "$FILESDIR/iasl-20200326-Makefile.patch"
find "${S}" -type f -name 'Makefile*' -print0 | \
	xargs -0 -I '{}' \
	sed -r -e 's:-\<Werror\>::g' -e "s:/usr:${EPREFIX}/usr:g" \
	-i '{}'
acheck

cd "${S}" || exit

make -C generate/unix PREFIX="/pkg/main/${PKG}.core.${PVRF}" BITS="${BITS}"

cd generate/unix || exit

make install PREFIX="/pkg/main/${PKG}.core.${PVRF}" DESTDIR="${D}" BITS="${BITS}"

finalize
