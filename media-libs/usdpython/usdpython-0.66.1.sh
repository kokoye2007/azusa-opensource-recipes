#!/bin/sh
source "../../common/init.sh"
inherit python

# list of programs to expose in bin
PROGRAMS="fixOpacity usdARKitChecker usdzaudioimport usdzconvert usdzcreateassetlib"

get https://github.com/KarpelesLab/usdpython/archive/refs/tags/v${PV}.tar.gz ${P}.tar.gz
#get https://download.developer.apple.com/WWDC_2022/USDPython_${PV}/USDPython${PV}.zip
#/pkg/main/app-arch.xar.core/bin/xar -x -f "USDPython-${PV}.pkg"
#cd "USDPython.component.pkg"
#cat Payload | gunzip | cpio -i
#cd Applications/usdpython
#S="$PWD"

acheck

cd "${S}"

# we only care about usdzconvert, since we already have USD through media-libs/usd
mkdir -pv "${D}/pkg/main/${PKG}.core.${PVRF}"
mv -v usdzconvert "${D}/pkg/main/${PKG}.core.${PVRF}/usdzconvert"
mkdir -pv "${D}/pkg/main/${PKG}.doc.${PVRF}"
mv README.md LICENSE samples "${D}/pkg/main/${PKG}.doc.${PVRF}"

cd "${D}/pkg/main/${PKG}.core.${PVRF}"
mkdir bin

for prog in $PROGRAMS; do
	cat >"bin/$prog" <<EOF
#!/pkg/main/app-shells.bash.core/bin/bash
# setup python env
export PYTHONHOME="/pkg/main/dev-lang.python.core.${PYTHON_LATEST%.*}"
export PYTHONPATH=":/pkg/main/dev-lang.python-modules.core.${PYTHON_LATEST%.*}/lib/python${PYTHON_LATEST%.*}:\$PYTHONHOME/lib/python${PYTHON_LATEST%.*}/lib-dynload:/pkg/main/media-libs.usd.mod/lib/python"
# run the requested tool
exec /pkg/main/dev-lang.python.core.${PYTHON_LATEST%.*}/bin/python${PYTHON_LATEST%.*} /pkg/main/${PKG}.core.${PVRF}/usdzconvert/$prog "\$@"
EOF
	chmod +x "bin/$prog"
done

finalize
