#!/bin/sh
source "../../common/init.sh"

get https://gitlab.com/lib"${PN}"/"${PN}"/-/archive/"${PV}"/"${P}".tar.gz
acheck

cd "${T}" || exit

importpkg dev-libs/boost dev-util/nvidia-cuda-toolkit:11.7 sci-libs/klu

OPTS=(
	-DCHOLMOD_INCLUDES="/pkg/main/sci-libs.cholmod.dev/include"
	-DCHOLMOD_LIBRARIES="/pkg/main/sci-libs.cholmod.libs/lib$LIB_SUFFIX"

	-DUMFPACK_INCLUDES="/pkg/main/sci-libs.umfpack.dev/include"
	-DUMFPACK_LIBRARIES="/pkg/main/sci-libs.umfpack.libs/lib$LIB_SUFFIX"

	-DKLU_INCLUDES="/pkg/main/sci-libs.klu.dev/include"
	-DKLU_LIBRARIES="/pkg/main/sci-libs.klu.libs/lib$LIB_SUFFIX"

	-DSPQR_INCLUDES="/pkg/main/sci-libs.spqr.dev/include"
	-DSPQR_LIBRARIES="/pkg/main/sci-libs.spqr.libs/lib$LIB_SUFFIX"

	-DSUPERLU_INCLUDES="/pkg/main/sci-libs.superlu.dev/include"
	-DSUPERLU_LIBRARIES="/pkg/main/sci-libs.superlu.libs/lib$LIB_SUFFIX"

	-DMPFR_INCLUDES="/pkg/main/dev-libs.mpfr.dev/include"
	-DMPFR_LIBRARIES="/pkg/main/dev-libs.mpfr.libs/lib$LIB_SUFFIX"

	-DGMP_INCLUDES="/pkg/main/dev-libs.gmp.dev/include"
	-DGMP_LIBRARIES="/pkg/main/dev-libs.gmp.libs/lib$LIB_SUFFIX"

	-DADOLC_INCLUDES="/pkg/main/sci-libs.adolc.dev/include"
	-DADOLC_LIBRARIES="/pkg/main/sci-libs.adolc.libs/lib$LIB_SUFFIX"

	# GOOGLEHASH_INCLUDES GOOGLEHASH_COMPILE

	-DEIGEN_TEST_NO_OPENGL=ON
	-DEIGEN_TEST_CXX11=ON
	-DEIGEN_TEST_NOQT=ON
	-DEIGEN_TEST_ALTIVEC=ON
	-DEIGEN_TEST_CUDA=ON
	-DEIGEN_TEST_OPENMP=OFF
	-DEIGEN_TEST_NEON64=ON
	-DEIGEN_TEST_VSX=ON
)

docmake "${OPTS[@]}"

finalize
