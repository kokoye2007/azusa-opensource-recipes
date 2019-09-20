#!/bin/sh
source "../../common/init.sh"

get ftp://ftp.vim.org/pub/vim/unix/${P}.tar.bz2

echo "#define SYS_VIMRC_FILE \"/pkg/main/${PKG}.core.${PVR}/etc/vimrc\"" >> vim81/src/feature.h

cd "${CHPATH}/vim81"

CFLAGS="-I/pkg/main/sys-libs.gpm.dev/include"
LDFLAGS="-L/pkg/main/sys-libs.gpm.dev/lib$LIB_SUFFIX"

importpkg ncurses tinfo

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
