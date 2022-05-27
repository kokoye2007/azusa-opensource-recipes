#!/bin/sh
source "../../common/init.sh"

get https://wayland.freedesktop.org/releases/${P}.tar.xz
acheck

cd "${T}"

domeson

finalize
