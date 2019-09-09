#!/bin/sh
source "../../common/init.sh"

get https://mirrors.edge.kernel.org/pub/software/scm/git/${P}.tar.xz

cd "${P}"

# configure & build
# NOTE: ncurses doesn't support --docdir
doconf

make
make install DESTDIR="${D}"

finalize
