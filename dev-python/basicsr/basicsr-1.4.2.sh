#!/bin/sh
source ../../common/init.sh
inherit python

PATCHES=(
	"$FILESDIR/${P}-fix-degradations.patch"
)

python_do_standard_package
