#!/bin/sh
source "../../common/init.sh"
inherit perl

get https://cpan.metacpan.org/authors/id/K/KE/KENTNL/${P}.tar.gz
acheck

cd "${P}"

perlsetup
finalize
