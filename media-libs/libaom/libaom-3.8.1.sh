#!/bin/sh
source "../../common/init.sh"

get https://storage.googleapis.com/aom-releases/"${P}".tar.gz
acheck

cd "${T}" || exit

CMAKEOPTS=(
	-DENABLE_CCACHE=OFF
	-DENABLE_DOCS=ON
	-DENABLE_EXAMPLES=OFF
	-DENABLE_NASM=OFF
	-DENABLE_TESTS=OFF
	-DENABLE_TOOLS=ON
	-DENABLE_WERROR=OFF
)

docmake "${CMAKEOPTS[@]}"

finalize
