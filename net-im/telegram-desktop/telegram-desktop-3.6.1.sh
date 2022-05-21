#!/bin/sh
source "../../common/init.sh"

get https://github.com/telegramdesktop/tdesktop/archive/v${PV}.tar.gz tdesktop-${PV}.tar.gz
acheck

# telegram doesn't build if not from its source dir
cd "${S}"

docmake

finalize
