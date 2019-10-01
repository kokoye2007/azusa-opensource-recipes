#!/bin/sh
source "../../common/init.sh"

for foo in andale32 arialb32 comic32 courie32 georgi32 impact32 webdin32 wd97vwr32; do
	get https://download.sourceforge.net/corefonts/$foo.exe
done
get mirror://gentoo/EUupdate.EXE

acheck

# TODO

finalize
