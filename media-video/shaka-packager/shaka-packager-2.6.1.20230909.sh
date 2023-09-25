#!/bin/sh
source "../../common/init.sh"

if [ "${PV}" != "2.6.1.20230909" ]; then
	die "revision update needed"
fi
REVISION="8465f5f020b5c6152d24107a6d164301e05c3176"

#get https://github.com/shaka-project/shaka-packager/archive/refs/tags/v${PV}.tar.gz ${P}.tar.gz
#fetchgit https://github.com/shaka-project/shaka-packager.git "$REVISION"

cd "${T}"

importpkg net-dns/c-ares

# The latest version of depot_tools will not work, so please use that branch!
git clone -b chrome/4147 https://chromium.googlesource.com/chromium/tools/depot_tools.git
touch depot_tools/.disable_auto_update
export PATH="${T}/depot_tools:$PATH"

# force python2
echo -e "#!/bin/sh\nexec /bin/python2 \"\$@\"" >${T}/depot_tools/python
chmod +x ${T}/depot_tools/python

export VPYTHON_BYPASS="manually managed python not supported by chrome operations"

"${T}/depot_tools/gclient" config https://github.com/shaka-project/shaka-packager.git --name=src --unmanaged
"${T}/depot_tools/gclient" sync -r "$REVISION"
acheck

find src/out/Release -name '*.ninja' | xargs sed -i -e 's/Werror/Wno-error/'

sed -i '/#include <string>/a #include <cstdint>' src/packager/media/base/fourccs.h src/packager/base/debug/profiler.h src/packager/hls/public/hls_params.h src/packager/hls/base/tag.h
sed -i '/#include <string.h>/a #include <cstdint>' src/packager/base/debug/stack_trace.cc
sed -i '/#include <vector>/a #include <cstdint>' src/packager/media/base/buffer_writer.h src/packager/media/base/id3_tag.h

ninja -C src/out/Release

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
cd src/out/Release
mv packager "${D}/pkg/main/${PKG}.core.${PVRF}/bin/shaka-packager"
mv mpd_generator "${D}/pkg/main/${PKG}.core.${PVRF}/bin"

finalize
