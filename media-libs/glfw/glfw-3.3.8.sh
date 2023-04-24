#!/bin/sh
source "../../common/init.sh"

get https://github.com/glfw/glfw/archive/${PV}.tar.gz "${P}.tar.gz"
acheck

cd "${T}"

importpkg X

docmake -DGLFW_BUILD_EXAMPLES=no -DGLFW_USE_WAYLAND=NO

finalize
