#!/bin/sh
source "../../common/init.sh"

get ftp://ftp.vim.org/pub/vim/unix/${P}.tar.bz2
acheck

echo "#define SYS_VIMRC_FILE \"/pkg/main/${PKG}.core.${PVR}/etc/vimrc\"" >> vim82/src/feature.h

cd "${CHPATH}/vim82"

importpkg ncurses tinfo sys-libs/gpm

doconf

make
make install DESTDIR="${D}"

cd "${D}"

mkdir -p "pkg/main/${PKG}.core.${PVR}/etc"

cat >"pkg/main/${PKG}.core.${PVR}/etc/vimrc" <<"EOF"
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
