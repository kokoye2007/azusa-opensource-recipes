#!/bin/sh
source "../../common/init.sh"

MY_P="Argyll_V${PV}"
get http://www.argyllcms.com/${MY_P}_src.zip
acheck

importpkg media-libs/tiff media-libs/libjpeg-turbo X

cd "${S}"

# Make it respect LDFLAGS
echo "LINKFLAGS += ${LDFLAGS} ;" >> Jamtop

# Evil hack to get --as-needed working. The build system unfortunately lists all
# the shared libraries by default on the command line _before_ the object to be built...
echo "STDLIBS += -ldl -lrt -lX11 -lXext -lXxf86vm -lXinerama -lXrandr -lXau -lXdmcp -lXss -ltiff -ljpeg ;" >> Jamtop

export CFLAGS="$CFLAGS -DUNIX -D_THREAD_SAFE -O2 ${CPPFLAGS}"

sed -e 's:CCFLAGS:CFLAGS:g' -i Jambase

export PREFIX=/pkg/main/${PKG}.core.${PVRF}
export DESTDIR="${D}"

jam -dx -fJambase

jam -dx -fJambase install

finalize
