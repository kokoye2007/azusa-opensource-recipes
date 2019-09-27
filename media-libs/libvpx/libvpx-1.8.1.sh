#!/bin/sh
source "../../common/init.sh"

get https://github.com/webmproject/${PN}/archive/v${PV}.tar.gz

acheck

cd "${T}"

doconflight --disable-examples --enable-pic --enable-vp9-highbitdepth --enable-vp8 --enable-vp9 --enable-postproc --enable-vp9-postproc --enable-runtime-cpu-detect --enable-shared --disable-static --enable-multi-res-encoding --enable-vp9-temporal-denoising --enable-webm-io --enable-libyuv

make
make install DESTDIR="${D}"

finalize
