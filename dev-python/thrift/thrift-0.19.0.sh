#!/bin/sh
source ../../common/init.sh
inherit python

get https://github.com/apache/thrift/archive/refs/tags/v"${PV}".tar.gz "${P}".tar.gz
acheck

export PYTHONDONTWRITEBYTECODE=1

cd "${S}/lib/py" || exit

pythonsetup
archive
