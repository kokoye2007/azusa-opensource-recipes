#!/bin/sh
source "../../common/init.sh"

get https://github.com/evanw/esbuild/archive/refs/tags/v${PV}.tar.gz "${P}.tar.gz"
acheck

cd "${S}"

#npm install --production
/bin/bash -i

finalize
