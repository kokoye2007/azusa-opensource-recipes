#!/bin/sh
source "../../common/init.sh"

get https://download.blender.org/source/${P}.tar.xz
acheck

cd "${T}"

PKGS=(
	libjpeg
	libpng
	media-libs/openjpeg
	media-libs/tiff

	media-libs/freetype
	media-libs/opencolorio
	media-libs/openimageio
	media-libs/embree
	dev-cpp/tbb
	dev-libs/gmp
	sys-devel/clang
	media-libs/libsdl2
	media-libs/openal
	media-libs/libsndfile
	sci-libs/fftw
	dev-libs/jemalloc
	media-gfx/openvdb
	dev-libs/boost
	media-libs/libharu
	dev-libs/lzo
	dev-cpp/eigen
	dev-libs/pugixml
	dev-libs/imath

	gl
	glew
	glu
	glut
	media-libs/openexr
)

importpkg "${PKGS[@]}"

PYTHON_VERSION="$(/pkg/main/dev-lang.python.core/bin/python3 --version | awk '{ print $2 }')"

CMAKEOPTS=(
	-DBUILD_SHARED_LIBS=OFF # to avoid inter-target dependency graph issues
	-DEigen3_ROOT=/pkg/main/dev-cpp.eigen.dev
	-DPYTHON_INCLUDE_DIR=/pkg/main/dev-lang.python.dev.$PYTHON_VERSION/include/python${PYTHON_VERSION%.*}
	-DPYTHON_LIBRARY=/pkg/main/dev-lang.python.libs.$PYTHON_VERSION/lib$LIB_SUFFIX
	-DPYTHON_VERSION=$PYTHON_VERSION
	-DWITH_ALEMBIC=ON
	-DWITH_ASSERT_ABORT=OFF
	-DWITH_BOOST=ON
	-DWITH_BULLET=ON
	-DWITH_CODEC_FFMPEG=ON
	-DWITH_CODEC_SNDFILE=ON
	-DWITH_CXX_GUARDEDALLOC=OFF
	-DWITH_CYCLES=ON
	-DWITH_CYCLES_DEVICE_CUDA=TRUE
	-DWITH_CYCLES_DEVICE_OPENCL=ON
	-DWITH_CYCLES_EMBREE=ON
	-DWITH_CYCLES_OSL=ON
	-DWITH_CYCLES_STANDALONE=ON
	-DWITH_CYCLES_STANDALONE_GUI=ON
	-DWITH_DOC_MANPAGE=ON
	-DWITH_FFTW3=ON
	-DWITH_GMP=ON
	-DWITH_GTESTS=OFF
	-DWITH_HARU=ON
	-DWITH_HEADLESS=ON
	-DWITH_INSTALL_PORTABLE=OFF
	-DWITH_IMAGE_DDS=ON
	-DWITH_IMAGE_OPENEXR=ON
	-DWITH_IMAGE_OPENJPEG=ON
	-DWITH_IMAGE_TIFF=ON
	-DWITH_INPUT_NDOF=ON
	-DWITH_INTERNATIONAL=ON
	-DWITH_JACK=ON
	-DWITH_MEM_JEMALLOC=ON
	-DWITH_MEM_VALGRIND=OFF
	-DWITH_MOD_FLUID=ON
	-DWITH_MOD_OCEANSIM=ON
	-DWITH_NANOVDB=OFF
	-DWITH_OPENAL=ON
	-DWITH_OPENCOLLADA=ON
	-DWITH_OPENCOLORIO=ON
	-DWITH_OPENIMAGEDENOISE=ON
	-DWITH_OPENIMAGEIO=ON
	-DWITH_OPENMP=ON
	-DWITH_OPENSUBDIV=ON
	-DWITH_OPENVDB=ON
	-DWITH_OPENVDB_BLOSC=ON
	-DWITH_POTRACE=ON
	-DWITH_PUGIXML=ON
	-DWITH_PULSEAUDIO=ON
	-DWITH_PYTHON_INSTALL=ON
	-DWITH_PYTHON_INSTALL_NUMPY=ON
	-DWITH_SDL=ON
	-DWITH_STATIC_LIBS=OFF
	-DWITH_SYSTEM_EIGEN3=ON
	-DWITH_SYSTEM_GLEW=ON
	-DWITH_SYSTEM_LZO=ON
	-DWITH_TBB=ON
	-DWITH_USD=OFF
	-DWITH_XR_OPENXR=OFF
)

docmake -G Ninja "${CMAKEOPTS[@]}"

ninja
DESTDIR="${D}" ninja install

finalize
