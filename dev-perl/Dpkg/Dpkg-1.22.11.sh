#!/bin/sh
source "../../common/init.sh"
inherit perl

get https://cpan.metacpan.org/authors/id/G/GU/GUILLEM/${P}.tar.gz
acheck

cd "${S}"

perlsetup
finalize
