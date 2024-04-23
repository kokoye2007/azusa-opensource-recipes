#!/bin/sh
source ../../common/init.sh
inherit python

pythondownload "$PN" "$PV"
get https://github.com/r9y9/open_jtalk/releases/download/v1.11.1/open_jtalk_dic_utf_8-1.11.tar.gz
acheck

importpkg sys-libs/llvm-libunwind # needed quite often

cd "${S}"

# Downloading: "https://github.com/r9y9/open_jtalk/releases/download/v1.11.1/open_jtalk_dic_utf_8-1.11.tar.gz"
# to: /pkg/main/dev-python.pyopenjtalk.mod.0.3.3.py3.12.2.linux.amd64/lib/python3.12/site-packages/pyopenjtalk/dic.tar.gz

pythonsetup
for sub in "${D}/pkg/main/${PKG}.mod.${PVR}.py"*; do
	cp -rv "$WORKDIR/open_jtalk_dic_utf_8-1.11" $sub/lib/python*/site-packages/pyopenjtalk/
done
archive
