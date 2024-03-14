#!/bin/sh
source ../../common/init.sh
inherit python

get https://github.com/apache/thrift/archive/refs/tags/v${PV}.tar.gz ${P}.tar.gz
acheck

cd "${S}/lib/py"

pythonsetup
archive
