#!/bin/sh
source "../../common/init.sh"

get https://poppler.freedesktop.org/"${P}".tar.gz
acheck

cd "${S}" || exit

make prefix="$(apfx core)" DESTDIR="${D}" install

# gentoo bug 409361
mkdir -p "$(dpfx core)/share/poppler/cMaps"
cd "$(dpfx core)/share/poppler/cMaps" || exit
find ../cMap -type f -exec ln -s {} . \;

finalize
