#!/bin/sh
source "../../common/init.sh"

get https://salsa.debian.org/apt-team/apt/-/archive/${PV}/${P}.tar.gz
acheck

cd "${T}"

importpkg zlib sys-libs/db app-arch/bzip2 dev-libs/libgpg-error dev-libs/xxhash sys-libs/libseccomp

export PATH="/pkg/main/app-misc.triehash.core/bin:$PATH"

sed -i '49i /pkg/main/sys-libs.db.dev/include' "${S}/CMake/FindBerkeley.cmake"

# for dpkg
ln -snfv /pkg/main/app-arch.dpkg.core/share/dpkg /usr/share/dpkg

# CMake Error at CMake/Documentation.cmake:44 (message):
#  Could not find docbook xsl


docmake -DWITH_DOC=OFF -DDPKG_DATADIR=/var/lib/dpkg

finalize
