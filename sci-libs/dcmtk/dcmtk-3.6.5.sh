#!/bin/sh
source "../../common/init.sh"

get https://dicom.offis.de/download/dcmtk/release/"${P}".tar.gz
acheck

cd "${T}" || exit

importpkg zlib media-libs/openjpeg media-libs/libsndfile dev-libs/icu

docmake -DDCMTK_WITH_ICU=ON -DDCMTK_WITH_TIFF=ON -DDCMTK_WITH_PNG=ON -DDCMTK_WITH_XML=ON -DDCMTK_WITH_ZLIB=ON -DDCMTK_WITH_OPENSSL=ON -DDCMTK_WITH_DOXYGEN=ON -DDCMTK_WITH_THREADS=ON

finalize
