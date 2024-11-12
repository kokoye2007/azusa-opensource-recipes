#!/bin/sh
source "../../common/init.sh"
inherit perl

get https://github.com/mquinson/po4a/releases/download/v"${PV}"/"${P}".tar.gz
acheck

cd "${P}" || exit

perlsetup
finalize
