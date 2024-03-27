#!/bin/sh
source "../../common/init.sh"

get https://archive.mozilla.org/pub/firefox/releases/${PV}/source/${P}.source.tar.xz
acheck

cd "${P}"

echo "AIzaSyAqAvJEBBA813_wwOAFMlXJgJ2BSZmIGR4" > google-key # azusa key
# TODO FIXME this is a LFS api key, pending Mozilla key
# https://location.services.mozilla.com/api
echo "d2284a20-0505-4927-a809-7ffaf4d91e55" > mozilla-key

cat > mozconfig <<EOF
# If you have a multicore machine, all cores will be used by default.

# If you have installed (or will install) wireless-tools, and you wish
# to use geolocation web services, comment out this line
#ac_add_options --disable-necko-wifi

# API Keys for geolocation APIs - necko-wifi (above) is required for MLS
# Uncomment the following line if you wish to use Mozilla Location Service
ac_add_options --with-mozilla-api-keyfile=$PWD/mozilla-key

# Uncomment the following line if you wish to use Google's geolocaton API
# (needed for use with saved maps with Google Maps)
ac_add_options --with-google-location-service-api-keyfile=$PWD/google-key

# Uncomment this line if you have installed startup-notification:
#ac_add_options --enable-startup-notification

# Uncomment the following option if you have not installed PulseAudio
#ac_add_options --disable-pulseaudio
# or uncomment this if you installed alsa-lib instead of PulseAudio
#ac_add_options --enable-alsa

# Comment out following options if you have not installed
# recommended dependencies:
ac_add_options --enable-system-sqlite
ac_add_options --with-system-libevent
# firefox-65 understands webp and ships with an included copy
ac_add_options --with-system-webp
ac_add_options --with-system-nspr
ac_add_options --with-system-nss
ac_add_options --with-system-icu

# Do not specify the gold linker which is not the default. It will take
# longer and use more disk space when debug symbols are disabled.

# You cannot distribute the binary if you do this
#ac_add_options --enable-official-branding

# If you are going to apply the patch for system graphite
# and system harfbuzz, uncomment these lines:
ac_add_options --with-system-graphite2
ac_add_options --with-system-harfbuzz

# Stripping is now enabled by default.
# Uncomment these lines if you need to run a debugger:
#ac_add_options --disable-strip
#ac_add_options --disable-install-strip

# Disabling debug symbols makes the build much smaller and a little
# faster. Comment this if you need to run a debugger. Note: This is
# required for compilation on i686.
ac_add_options --disable-debug-symbols

# The BLFS editors recommend not changing anything below this line:
ac_add_options --prefix=/pkg/main/${PKG}.core.${PVRF}
ac_add_options --enable-application=browser

# The elf-hack is reported to cause failed installs (after successful builds)
# on some machines. It is supposed to improve startup time and it shrinks
# libxul.so by a few MB - comment this if you know your machine is not affected.
ac_add_options --disable-elf-hack

ac_add_options --disable-crashreporter
ac_add_options --disable-updater
# enabling the tests will use a lot more space and significantly
# increase the build time, for no obvious benefit.
ac_add_options --disable-tests

# The default level of optimization again produces a working build with gcc.
ac_add_options --enable-optimize

# From firefox-61 system cairo is not supported

ac_add_options --enable-system-ffi
ac_add_options --enable-system-pixman

# From firefox-62 --with-pthreads is not recognized

ac_add_options --with-system-bz2
ac_add_options --with-system-jpeg
ac_add_options --with-system-png
ac_add_options --with-system-zlib

# The following option unsets Telemetry Reporting. With the Addons Fiasco,
# Mozilla was found to be collecting user's data, including saved passwords and
# web form data, without users consent. Mozilla was also found shipping updates
# to systems without the user's knowledge or permission.
# As a result of this, use the following command to permanently disable
# telemetry reporting in Firefox.
unset MOZ_TELEMETRY_REPORTING

mk_add_options MOZ_OBJDIR=@TOPSRCDIR@/firefox-build-dir
EOF

case $(uname -m) in
   i?86) sed -i "562 s/mips64/i386/" gfx/skia/skia/third_party/skcms/src/Transform_inl.h ;;
esac

export CC=gcc CXX=g++
export MOZBUILD_STATE_PATH=${PWD}/mozbuild
export SHELL=/bin/sh

./mach build
./mach install

mkdir -p "${D}/pkg/main"
mv /.pkg-main-rw/${PKG}.core.${PVRF} "${D}/pkg/main/${PKG}.core.${PVRF}"

finalize
