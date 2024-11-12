#!/bin/sh
source "../../common/init.sh"

get https://dl.hexchat.net/hexchat/"${P}".tar.xz
acheck

cd "${T}" || exit

domeson

finalize
