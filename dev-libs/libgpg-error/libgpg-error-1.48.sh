#!/bin/sh
source "../../common/init.sh"

get https://www.gnupg.org/ftp/gcrypt/"${PN}"/"${P}".tar.bz2
acheck

cd "${T}" || exit

doconf --enable-threads=posix --disable-static --disable-tests

# disable gpg-error-config-test because it checks if output is the same but because we got version number in the path it can't
echo $'#!/bin/sh\nexit 0' >"src/gpg-error-config-test.sh"

make
make install DESTDIR="${D}"

finalize
