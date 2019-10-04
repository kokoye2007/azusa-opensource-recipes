#!/bin/sh
source "../../common/init.sh"

get https://www.cpan.org/authors/id/P/PH/PHRED/${P}.tar.gz
acheck

cd "${P}"

perl Makefile.PL
make

make install

finalize
