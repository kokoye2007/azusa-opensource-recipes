#!/bin/sh
source "../../common/init.sh"

inherit llvm

llvmget lldb llvm

acheck

llvmbuild

finalize
