#!/bin/sh
source "../../common/init.sh"

get https://www.zsh.org/pub/"${P}".tar.xz
acheck

cd "${T}" || exit

importpkg sys-libs/ncurses

doconf --enable-function-subdirs --with-tcsetpgrp --with-term-lib='tinfow ncursesw' --enable-maildir-support --enable-pcre --enable-cap --enable-multibyte --enable-gdbm

# --enable-runhelpdir="${EPREFIX}"/usr/share/zsh/${PV%_*}/help
# --enable-fndir="${EPREFIX}"/usr/share/zsh/${PV%_*}/functions
# --enable-site-fndir="${EPREFIX}"/usr/share/zsh/site-functions

make
make install DESTDIR="${D}"

finalize
