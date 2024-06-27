#!/bin/sh
source "../../common/init.sh"

NEUTRINO_PV=2.4

get https://studio-neutrino.com/downloads/v${NEUTRINO_PV}/NEUTRINO-online-v${PV}.zip
acheck

mkdir -v -p "${D}/pkg/main/${PKG}.data.${PVRF}"
mv -v "${S}" "${D}/pkg/main/${PKG}.core.${PVRF}"

# go into new pkg
cd "${D}/pkg/main/${PKG}.core.${PVRF}"

# move models to separate package
rm -fr model
mkdir model
for m in itako jsut kiritan merrow metan nakumo seven yoko zundamon zunko; do
	ln -snfv "/pkg/main/media-sound.neutrino-data.data.${m}.${NEUTRINO_PV}/model" "model/$(echo $m | tr a-z A-Z)"
done

# cleanup libs
rm -v bin/lib*.so*

# add +x flag (missing since it was in a .zip file)
chmod -v +x bin/*

# let fixelf/etc do the work
finalize
