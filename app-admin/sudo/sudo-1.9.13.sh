#!/bin/sh
source "../../common/init.sh"

get https://www.sudo.ws/dist/"${P}".tar.gz
acheck

cd "${T}" || exit

importpkg zlib sys-libs/pam

doconf --enable-zlib=system --enable-tmpfiles.d=/usr/lib/tmpfiles.d --with-editor=/usr/libexec/editor --with-env-editor --with-plugindir=/pkg/main/"${PKG}".libs."${PVRF}"/sudo --with-rundir=/run/sudo --with-vardir=/var/db/sudo --without-linux-audit --without-opie --with-pam

make
make install DESTDIR="${D}"

finalize
