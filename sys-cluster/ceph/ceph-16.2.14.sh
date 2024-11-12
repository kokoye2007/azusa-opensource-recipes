#!/bin/sh
source "../../common/init.sh"
inherit python

get https://download.ceph.com/tarballs/"${P}".tar.gz
acheck

# use system boost
# We don't use system boost since it looks like it's not working right :(
#find "${S}" -name '*.cmake' -or -name 'CMakeLists.txt' -print0 | xargs --null sed -r  -e 's|Boost::|boost_|g' -e 's|Boost_|boost_|g' -e 's|[Bb]oost_boost|boost_system|g' -i

# snappy 1.1.9 will fail
importpkg \
	sys-fs/eudev sys-apps/util-linux sys-apps/keyutils net-nds/openldap app-crypt/mit-krb5 sys-block/libzbd \
	sys-process/numactl dev-util/cunit dev-libs/libaio dev-db/sqlite dev-libs/leveldb app-arch/snappy:1.1.10 app-arch/lz4 \
	dev-util/google-perftools sys-auth/oath-toolkit dev-lang/python sys-libs/zlib dev-util/lttng-ust \
	dev-libs/rocksdb:6.15 dev-libs/boost dev-lang/lua sys-libs/liburing sys-libs/ncurses dev-libs/libnl dev-libs/icu \
	net-libs/rabbitmq-c dev-libs/librdkafka dev-libs/pmdk dev-libs/userspace-rcu dev-libs/openssl app-arch/zstd \
	sys-libs/libcap-ng dev-libs/expat net-misc/curl

PATCHES=(
	"${FILESDIR}/ceph-12.2.0-use-provided-cpu-flag-values.patch"
	"${FILESDIR}/ceph-14.2.0-cflags.patch"
	"${FILESDIR}/ceph-12.2.4-boost-build-none-options.patch"
	"${FILESDIR}/ceph-16.2.2-cflags.patch"
	"${FILESDIR}/ceph-16.2.8-no-virtualenvs.patch"
	"${FILESDIR}/ceph-13.2.2-dont-install-sysvinit-script.patch"
	"${FILESDIR}/ceph-14.2.0-dpdk-cflags.patch"
	"${FILESDIR}/ceph-14.2.0-cython-0.29.patch"
	"${FILESDIR}/ceph-16.2.0-rocksdb-cmake.patch"
	"${FILESDIR}/ceph-15.2.3-spdk-compile.patch"
	"${FILESDIR}/ceph-16.2.0-spdk-tinfo.patch"
	"${FILESDIR}/ceph-16.2.0-jaeger-system-boost.patch"
	"${FILESDIR}/ceph-16.2.0-liburing.patch"
	"${FILESDIR}/ceph-16.2.2-system-zstd.patch"
	"${FILESDIR}/ceph-17.2.0-fuse3.patch"
	"${FILESDIR}/ceph-17.2.0-gcc12-header.patch"
	"${FILESDIR}/ceph-16.2.10-flags.patch"
	"${FILESDIR}/ceph-17.2.5-boost-1.81.patch"
	"${FILESDIR}/ceph-16.2.14-gcc13.patch"
	# https://bugs.gentoo.org/907739
	"${FILESDIR}/ceph-18.2.0-cython3.patch"
)

cd "${S}" || exit

apatch "${PATCHES[@]}"

cd "${T}" || exit

# minimal config to find plugins
cat <<EOF > ceph.conf
[global]
plugin dir = lib
erasure code dir = lib
EOF

CMAKEOPTS=(
	-DWITH_BABELTRACE=NO
	-DWITH_BLUESTORE_PMEM=YES
	-DWITH_CEPHFS=YES
	-DWITH_CEPHFS_SHELL=YES
	-DWITH_DPDK=NO # disabled because failure to build
	-DWITH_SPDK=NO # same
	-DWITH_FUSE=YES
	-DWITH_LTTNG=YES
	-DWITH_GSSAPI=YES
	-DWITH_GRAFANA=YES
	-DWITH_MGR=YES
	-DWITH_MGR_DASHBOARD_FRONTEND=OFF
	-DWITH_OPENLDAP=YES
	-DWITH_PYTHON3="$PYTHON_LATEST"
	-DWITH_RADOSGW=YES
	-DWITH_RADOSGW_AMQP_ENDPOINT=YES
	-DWITH_RADOSGW_KAFKA_ENDPOINT=NO
	-DWITH_RADOSGW_LUA_PACKAGES=YES
	-DWITH_RBD_RWL=YES
	-DWITH_RBD_SSD_CACHE=YES
	-DWITH_SYSTEMD=NO
	-DWITH_TESTS=NO
	-DWITH_LIBURING=YES
	-DWITH_SYSTEM_LIBURING=YES
	-DWITH_LIBCEPHSQLITE=YES
	-DWITH_XFS=YES
	-DWITH_ZBD=YES
	-DWITH_ZFS=YES
	-DENABLE_SHARED:BOOL=ON
	-DWITH_MANPAGE:BOOL=OFF
	-DALLOCATOR=tcmalloc
	-DWITH_SYSTEM_PMDK=YES
	-DWITH_SYSTEM_BOOST=YES
	-DWITH_SYSTEM_ROCKSDB=ON
	-DWITH_RDMA=OFF
	#-DEPYTHON_VERSION=3
	-DCMAKE_INSTALL_DOCDIR="/pkg/main/${PKG}.doc.${PVRF}"
	-DCMAKE_INSTALL_SYSCONFDIR=/etc
	# needed for >=glibc-2.32
	-DWITH_REENTRANT_STRSIGNAL:BOOL=ON
	-Wno-dev
)

LD_LIBRARY_PATH="${T}/lib" docmake "${CMAKEOPTS[@]}" || /bin/bash -i

finalize
