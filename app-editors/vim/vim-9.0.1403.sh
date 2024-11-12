#!/bin/sh
source "../../common/init.sh"

get https://github.com/vim/vim/archive/v"${PV}".tar.gz "${P}.tar.gz"
acheck

cd "${S}" || exit

echo "#define SYS_VIMRC_FILE \"/pkg/main/${PKG}.core.${PVRF}/etc/vimrc\"" >> src/feature.h

importpkg ncurses tinfo sys-libs/gpm

doconf

make
make install DESTDIR="${D}"

cd "${D}" || exit

mkdir -p "pkg/main/${PKG}.core.${PVRF}/etc"

cat >"pkg/main/${PKG}.core.${PVRF}/etc/vimrc" <<"EOF"
" Begin /etc/vimrc

" Ensure defaults are set before customizing settings, not after
source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1

set nocompatible
set backspace=2
set mouse=
syntax on
if (&term == "xterm") || (&term == "putty")
 set background=dark
endif

" End /etc/vimrc
EOF

finalize
