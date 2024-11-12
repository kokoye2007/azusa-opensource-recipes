#!/bin/sh
source "../../common/init.sh"

get https://github.com/Z3Prover/z3/archive/"${P}".tar.gz
acheck

importpkg gmp

cd */ || exit

doconflight --gmp

cd build || exit

# config.mk is missing -L flag for libgmp in SLINK_EXTRA_FLAGS=
sed -i -e "s,^SLINK_EXTRA_FLAGS=,SLINK_EXTRA_FLAGS=$(pkg-config --libs-only-L gmp) ," config.mk

make -j"$NPROC"
make install DESTDIR="${D}"

finalize
