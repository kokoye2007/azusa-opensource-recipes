#!/bin/sh
source "../../common/init.sh"

get http://www.festvox.org/${PN}/packed/${P}/${P}-release.tar.bz2

mkdir -p "${D}/pkg/main/${PKG}.data.${PVR}"
cd "${D}/pkg/main/${PKG}.data.${PVR}"

for foo in indic_ben_rm indic_guj_ad indic_guj_dp indic_guj_kt indic_hin_ab indic_kan_plv indic_mar_aup indic_mar_slp indic_pan_amp indic_tam_sdr indic_tel_kpn indic_tel_sk indic_tel_ss us_aew us_ahw us_aup us_awb us_axb us_bdl us_clb us_eey us_fem us_gka us_jmk us_ksp us_ljm us_lnh us_rms us_rxr us_slp us_slt; do
	get http://www.festvox.org/${PN}/packed/${P}/voices/cmu_${foo}.flitevox ${P}-cmu_${foo}.flitevox
	mv ${P}-cmu_${foo}.flitevox cmu_${foo}.flitevox
done

acheck

cd "$S"

PATCHES=(
	"${FILESDIR}"/${P}-Only-write-audio-data-to-a-temporariy-file-in-debug-.patch
	"${FILESDIR}"/${P}-Improve-internal-linking.patch
	"${FILESDIR}"/${PN}-1.4-audio-interface.patch
	"${FILESDIR}"/${P}-prototype.patch
)

apatch "${PATCHES[@]}"

sed -i main/Makefile \
	-e '/-rpath/s|$(LIBDIR)|$(INSTALLLIBDIR)|g'

mv configure.{in,ac}

aautoreconf

importpkg media-sound/pulseaudio

doconf --enable-shared --with-audio=pulseaudio

make
make install DESTDIR="${D}"

finalize
