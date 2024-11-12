#!/bin/sh
source "../../common/init.sh"
inherit perl

get https://www.cpan.org/authors/id/I/IS/ISHIGAKI/"${P}".tar.gz
acheck

cd "${P}" || exit

perlsetup
finalize
