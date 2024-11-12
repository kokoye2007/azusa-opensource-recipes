#!/bin/sh
source "../../common/init.sh"
inherit python

get https://download.blender.org/source/"${P}".tar.xz
acheck

cd "${S}" || exit

apatch "$FILESDIR/blender-3.0.1-openexr.patch" \
	"$FILESDIR/blender-3.0.1-openimageio-2.3.patch" \
	"$FILESDIR/blender-3.0.1-ffmpeg-5.0.patch" \
	"$FILESDIR/blender-3.3.0-fix-build-with-boost-1.81.patch"

# slot
BV="${PV%.*}"

# Disable MS Windows help generation. The variable doesn't do what it
# it sounds like.
sed -e "s|GENERATE_HTMLHELP      = YES|GENERATE_HTMLHELP      = NO|" \
	-i doc/doxygen/Doxyfile

# Prepare icons and .desktop files for slotting.
sed -e "s|blender.svg|blender-${BV}.svg|" -i source/creator/CMakeLists.txt
sed -e "s|blender-symbolic.svg|blender-${BV}-symbolic.svg|" -i source/creator/CMakeLists.txt
sed -e "s|blender.desktop|blender-${BV}.desktop|" -i source/creator/CMakeLists.txt
sed -e "s|blender-thumbnailer.py|blender-${BV}-thumbnailer.py|" -i source/creator/CMakeLists.txt

sed -e "s|Name=Blender|Name=Blender ${PV}|" -i release/freedesktop/blender.desktop
sed -e "s|Exec=blender|Exec=blender-${BV}|" -i release/freedesktop/blender.desktop
sed -e "s|Icon=blender|Icon=blender-${BV}|" -i release/freedesktop/blender.desktop

mv release/freedesktop/icons/scalable/apps/blender.svg release/freedesktop/icons/scalable/apps/blender-"${BV}".svg
mv release/freedesktop/icons/symbolic/apps/blender-symbolic.svg release/freedesktop/icons/symbolic/apps/blender-"${BV}"-symbolic.svg
mv release/freedesktop/blender.desktop release/freedesktop/blender-"${BV}".desktop
mv release/bin/blender-thumbnailer.py release/bin/blender-"${BV}"-thumbnailer.py

cd "${T}" || exit

PKGS=(
	libjpeg
	libpng
	zlib
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
	media-gfx/openvdb:9
	dev-libs/boost
	media-libs/libharu
	dev-libs/lzo
	dev-cpp/eigen
	dev-libs/pugixml
	media-libs/osl
	media-gfx/potrace
	media-gfx/alembic
	media-video/ffmpeg

	gl
	glew
	glu
	glut
	media-libs/openexr
	dev-libs/imath
	Imath
)

# ilmbase + openexr2 or imath+openexr3 ?
# openimage depend on imath/openexr3

importpkg "${PKGS[@]}"

CMAKEOPTS=(
	-DBUILD_SHARED_LIBS=OFF # to avoid inter-target dependency graph issues
	-DEigen3_ROOT=/pkg/main/dev-cpp.eigen.dev
	-DPYTHON_INCLUDE_DIR=/pkg/main/dev-lang.python.dev.$PYTHON_LATEST/include/python${PYTHON_LATEST%.*}
	-DPYTHON_LIBRARY=/pkg/main/dev-lang.python.libs.$PYTHON_LATEST/lib$LIB_SUFFIX/libpython${PYTHON_LATEST%.*}.so
	-DPYTHON_VERSION=${PYTHON_LATEST}
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
	-DWITH_PYTHON_INSTALL=OFF
	-DPYTHON_NUMPY_PATH=/pkg/main/dev-python.numpy.mod/lib/python${PYTHON_LATEST%.*}/site-packages/numpy
	-DPYTHON_NUMPY_INCLUDE_DIRS=/pkg/main/dev-python.numpy.mod/lib/python${PYTHON_LATEST%.*}/site-packages/numpy/core/include
	-DWITH_SDL=ON
	-DWITH_STATIC_LIBS=OFF
	-DWITH_SYSTEM_EIGEN3=ON
	-DWITH_SYSTEM_GLEW=ON
	-DWITH_SYSTEM_LZO=ON
	-DWITH_TBB=ON
	-DWITH_USD=OFF
	-DWITH_XR_OPENXR=OFF
)

docmake "${CMAKEOPTS[@]}"

# /build/blender-2.93.9/dist/pkg/main/media-gfx.blender.core.2.93.9.linux.amd64/share/man/man1/blender.1
mv -v "${D}/pkg/main/${PKG}.core.${PVRF}/share/man/man1/blender.1" "${D}/pkg/main/${PKG}.core.${PVRF}/share/man/man1/blender-${BV}.1"
mkdir -pv "${D}/pkg/main/${PKG}.core.${PVRF}/libexec"
mv -v "${D}/pkg/main/${PKG}.core.${PVRF}/bin/blender" "${D}/pkg/main/${PKG}.core.${PVRF}/libexec/blender-${BV}"

# create a fake blender executable which sets the required PYTHONHOME and PYTHONPATH variables for blender to work
cat >"${D}/pkg/main/${PKG}.core.${PVRF}/bin/blender-${BV}" <<EOF
#!/bin/bash
export PYTHONHOME="/pkg/main/dev-lang.python.core.${PYTHON_LATEST%.*}"
export PYTHONPATH=":/pkg/main/dev-lang.python-modules.core.${PYTHON_LATEST%.*}/lib/python${PYTHON_LATEST%.*}:\$PYTHONHOME/lib/python${PYTHON_LATEST%.*}/lib-dynload"
exec "/pkg/main/${PKG}.core.${PVRF}/libexec/blender-${BV}" "\$@"
EOF
chmod +x "${D}/pkg/main/${PKG}.core.${PVRF}/bin/blender-${BV}"

finalize
