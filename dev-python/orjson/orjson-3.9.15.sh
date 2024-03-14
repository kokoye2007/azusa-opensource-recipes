#!/bin/sh
source ../../common/init.sh
inherit python

importpkg sys-libs/llvm-libunwind

python_do_standard_package
