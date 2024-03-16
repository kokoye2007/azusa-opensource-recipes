#!/bin/sh
source ../../common/init.sh
inherit python

get "https://github.com/TimDettmers/bitsandbytes/archive/refs/tags/${PV}.tar.gz" ${P}.tar.gz
acheck

cd "${S}"

pythonsetup
archive
