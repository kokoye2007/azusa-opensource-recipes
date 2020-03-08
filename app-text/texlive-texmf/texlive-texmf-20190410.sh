#!/bin/sh
source "../../common/init.sh"

get ftp://tug.org/texlive/historic/${PV:0:4}/texlive-${PV}-texmf.tar.xz
acheck

/bin/bash -i
exit

finalize
