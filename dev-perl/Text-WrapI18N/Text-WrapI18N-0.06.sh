#!/bin/sh
source "../../common/init.sh"
inherit perl

get https://cpan.metacpan.org/authors/id/K/KU/KUBOTA/${P}.tar.gz
acheck

cd "${S}"

perlsetup
finalize
