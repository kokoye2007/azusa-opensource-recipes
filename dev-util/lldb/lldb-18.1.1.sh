#!/bin/sh
source "../../common/init.sh"

inherit llvm

llvmget lldb llvm

acheck

importpkg zlib

llvmbuild

finalize
