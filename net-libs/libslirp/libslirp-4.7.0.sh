#!/bin/sh
source "../../common/init.sh"

get https://gitlab.freedesktop.org/slirp/libslirp/-/archive/v${PV}/${MY_P}.tar.gz ${P}.tar.gz
acheck

cd "${S}"

echo "${PV}" > .tarball-version
echo -e "#!/bin/bash\necho -n \$(cat '${S}/.tarball-version')" > build-aux/git-version-gen || die

cd "${T}"

domeson -Ddefault_library=both

finalize
