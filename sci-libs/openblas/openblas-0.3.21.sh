#!/bin/sh
source "../../common/init.sh"

get https://github.com/xianyi/OpenBLAS/archive/v${PV}.tar.gz ${P}.tar.gz
acheck

cd "${S}"

export USE_THREAD=1
export USE_OPENMP=0 # pthread
export MAKE_NB_JOBS=-1
export COMMON_OPT=" "
export FCOMMON_OPT=" "
export DYNAMIC_ARCH=1
export NO_AFFINITY=1
export TARGET=GENERIC
export NUM_PARALLEL=8
export NUM_THREADS=64
export NO_STATIC=1
export BUILD_RELAPACK=1
export PREFIX=/pkg/main/${PKG}.core.${PVRF}

sed -e "/^all ::/s/tests //" -i Makefile

cp -aL "${S}" "${S}-index-64bit"

make
#cd interface
#make shared-blas-lapack

make -C"${S}-index-64bit" INTERFACE64=1 LIBPREFIX=libopenblas64

make install DESTDIR="${D}"
ls -la "${D}/pkg/main/${PKG}.core.${PVRF}"

cp -av "${S}-index-64bit"/libopenblas64*.so* "${D}/pkg/main/${PKG}.core.${PVRF}/lib"

finalize
