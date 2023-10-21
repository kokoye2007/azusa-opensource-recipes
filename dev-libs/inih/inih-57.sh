#!/bin/sh
source "../../common/init.sh"

get https://github.com/benhoyt/inih/archive/r${PV}.tar.gz $P.tar.gz
acheck

cd "${T}"

domeson -Ddefault_library=shared -Ddistro_install=true -Dwith_INIReader=true

finalize
