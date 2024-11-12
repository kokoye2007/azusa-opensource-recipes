#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/parted/parted-"${PV}".tar.xz
acheck

cd "${T}" || exit

importpkg sys-apps/util-linux sys-fs/lvm2 sys-libs/readline sys-libs/ncurses

export CFLAGS="-static -pthread"
export LDFLAGS="-static -pthread -L/pkg/main/sys-fs.lvm2-static.libs/lib -L/pkg/main/sys-apps.util-linux.libs/lib"
export LIBS="-lblkid -lm" # static libs

# TODO give path of the static libdevmapper
# /pkg/main/sys-fs.lvm2-static.libs/lib64
doconf --enable-all-static --without-readline --disable-nls --disable-shared --disable-dynamic-loading

# fix calls to major() and minor()
echo "#include <sys/sysmacros.h>" >>lib/config.h

make V=1

# parted is unable to correctly build itself statically, so let's do it
showrun() {
	echo "Running: $*"
	"$@"
}

TARGET="${D}/pkg/main/${PKG}.core.${PVR}/sbin"
mkdir -p "$TARGET"

cd parted || exit
showrun gcc "$LDFLAGS" -Wl,--as-needed -o parted.static command.o parted.o strlist.o ui.o table.o  libver.a ../libparted/.libs/libparted.a -ldevmapper -luuid "$LIBS"
cp -v parted.static "$TARGET"
cd ../partprobe || exit
showrun gcc "$LDFLAGS" -o partprobe.static partprobe.o ../libparted/.libs/libparted.a -ldevmapper -luuid "$LIBS"
cp -v partprobe.static "$TARGET"

finalize
