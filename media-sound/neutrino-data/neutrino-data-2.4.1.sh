#!/bin/sh
source "../../common/init.sh"

declare -A voices

NEUTRINO_PV=2.4

voices["merrow"]=https://studio-neutrino.com/downloads/v${NEUTRINO_PV}/%E3%82%81%E3%82%8D%E3%81%86%EF%BC%88NEUTRINO-Library%EF%BC%89-v${PV}.zip
voices["nakumo"]=https://studio-neutrino.com/downloads/v${NEUTRINO_PV}/%E3%83%8A%E3%82%AF%E3%83%A2%EF%BC%88NEUTRINO-Library%EF%BC%89-v${PV}.zip
voices["seven"]=https://studio-neutrino.com/downloads/v${NEUTRINO_PV}/No.7%EF%BC%88NEUTRINO-Library%EF%BC%89-v${PV}.zip
voices["itako"]=https://studio-neutrino.com/downloads/v${NEUTRINO_PV}/%E6%9D%B1%E5%8C%97%E3%82%A4%E3%82%BF%E3%82%B3%EF%BC%88NEUTRINO-Library%EF%BC%89-v${PV}.zip
voices["zunko"]=https://studio-neutrino.com/downloads/v${NEUTRINO_PV}/%E6%9D%B1%E5%8C%97%E3%81%9A%E3%82%93%E5%AD%90%EF%BC%88NEUTRINO-Library%EF%BC%89-v${PV}.zip
voices["kiritan"]=https://studio-neutrino.com/downloads/v${NEUTRINO_PV}/%E6%9D%B1%E5%8C%97%E3%81%8D%E3%82%8A%E3%81%9F%E3%82%93%EF%BC%88NEUTRINO-Library%EF%BC%89-v${PV}.zip
voices["zundamon"]=https://studio-neutrino.com/downloads/v${NEUTRINO_PV}/%E3%81%9A%E3%82%93%E3%81%A0%E3%82%82%E3%82%93%EF%BC%88NEUTRINO-Library%EF%BC%89-v${PV}.zip
voices["metan"]=https://studio-neutrino.com/downloads/v${NEUTRINO_PV}/%E5%9B%9B%E5%9B%BD%E3%82%81%E3%81%9F%E3%82%93%EF%BC%88NEUTRINO-Library%EF%BC%89-v${PV}.zip
voices["yoko-basic"]=https://studio-neutrino.com/downloads/v${NEUTRINO_PV}/%E8%AC%A1%E5%AD%90%EF%BC%88NEUTRINO-Library%EF%BC%89-v${PV}-basic.zip
voices["jsut-basic"]=https://studio-neutrino.com/downloads/v${NEUTRINO_PV}/JSUT%EF%BC%88NEUTRINO-Library%EF%BC%89-v${PV}-basic.zip

for voice in ${!voices[@]}; do
	mkdir -p "${D}/pkg/main/${PKG}.data.${voice}.${NEUTRINO_PV}.${PVRF}/model"
	cd "${D}/pkg/main/${PKG}.data.${voice}.${NEUTRINO_PV}.${PVRF}/model"
	download ${voices[$voice]} "neutrino-data-${PV}-${voice}.zip"
	unzip -j "neutrino-data-${PV}-${voice}.zip"
	rm -f "neutrino-data-${PV}-${voice}.zip"
done

archive
