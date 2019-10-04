#!/bin/sh
source "../../common/init.sh"
inherit perl

get https://cpan.metacpan.org/authors/id/P/PE/PEVANS/${P}.tar.gz
acheck

cd "${P}"

perlsetup
finalize
