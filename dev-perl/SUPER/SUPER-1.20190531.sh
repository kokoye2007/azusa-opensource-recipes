#!/bin/sh
source "../../common/init.sh"
inherit perl

get https://cpan.metacpan.org/authors/id/C/CH/CHROMATIC/${P}.tar.gz
acheck

cd "${P}"

perlsetup
finalize
