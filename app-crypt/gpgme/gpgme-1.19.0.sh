#!/bin/sh
source "../../common/init.sh"
inherit python

get https://www.gnupg.org/ftp/gcrypt/"${PN}"/"${P}".tar.bz2
acheck

cd "${T}" || exit

importpkg dev-libs/libassuan dev-libs/libgpg-error

export PYTHON_VERSION="${PYTHON_LATEST%.*}"

## TODO qt5
doconf --disable-gpgconf-test --disable-gpg-test --disable-gpgsm-test --disable-g13-test --enable-languages="cl cpp"

make
make install DESTDIR="${D}"

cd lang/python || exit

pythonsetup

finalize
