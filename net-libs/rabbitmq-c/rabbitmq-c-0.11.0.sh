#!/bin/sh
source "../../common/init.sh"

get https://github.com/alanxz/rabbitmq-c/archive/refs/tags/v${PV}.tar.gz
acheck

cd "${T}"

docmake

make
make install DESTDIR="${D}"

finalize
