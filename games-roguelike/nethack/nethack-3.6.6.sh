#!/bin/sh
source "../../common/init.sh"

get https://www.nethack.org/download/${PV}/nethack-362-src.tgz
acheck

importpkg ncurses

cd "${S}"

export HACKDIR="/pkg/main/${PKG}.core.${PVRF}/nethack"
export INSTDIR="${D}$HACKDIR"
export SHELLDIR="${D}/pkg/main/${PKG}.core.${PVRF}/bin"
export VARDIR="/var/games/nethack"
export CC=gcc
export WINTTYLIB="$(pkg-config --libs ncurses)"

CFLAGS="$CFLAGS $CPPFLAGS -I../include -DDLB -DSECURE -DTIMED_DELAY -DVISION_TABLES -DDUMPLOG -DSCORE_ON_BOTL -DCOMPRESS=\\\"/bin/gzip\\\" -DCOMPRESS_EXTENSION=\\\".gz\\\" -DHACKDIR=\\\"$HACKDIR\\\" -DVAR_PLAYGROUND=\\\"$VARDIR\\\" -DDEF_PAGER=\\\"/bin/less\\\" -DSYSCF -DSYSCF_FILE=\\\"/etc/nethack.sysconf\\\""

export CFLAGS

cp "$FILESDIR/nethack-3.6.0-hint-tty" hint
sys/unix/setup.sh hint


# if X: -DX11_GRAPHICS -DUSE_XPM

make nethack recover Guidebook spec_levs
make -j1 all

mkdir -pv "$SHELLDIR"

make install

mkdir "${D}/pkg/main/${PKG}.core.${PVRF}/etc"
cp sys/unix/sysconf "${D}/pkg/main/${PKG}.core.${PVRF}/etc/nethack.sysconf"

finalize
