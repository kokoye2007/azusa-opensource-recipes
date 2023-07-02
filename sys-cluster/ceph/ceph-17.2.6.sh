#!/bin/sh
source "../../common/init.sh"
inherit python

get https://download.ceph.com/tarballs/${P}.tar.gz
acheck

# use system boost
find "${S}" -name '*.cmake' -or -name 'CMakeLists.txt' -print0 | xargs --null sed -r  -e 's|Boost::|boost_|g' -e 's|Boost_|boost_|g' -e 's|[Bb]oost_boost|boost_system|g' -i

# snappy 1.1.9 will fail
importpkg \
	sys-fs/eudev sys-apps/util-linux sys-apps/keyutils net-nds/openldap app-crypt/mit-krb5 sys-block/libzbd \
	sys-process/numactl dev-util/cunit dev-libs/libaio dev-db/sqlite dev-libs/leveldb app-arch/snappy:1.1.10 app-arch/lz4 \
	dev-util/google-perftools sys-auth/oath-toolkit dev-lang/python sys-libs/zlib dev-util/lttng-ust \
	dev-libs/rocksdb:6.15 dev-libs/boost:1.81 dev-lang/lua sys-libs/liburing sys-libs/ncurses dev-libs/libnl dev-libs/icu \
	net-libs/rabbitmq-c dev-libs/librdkafka dev-libs/pmdk dev-libs/userspace-rcu dev-libs/openssl dev-libs/thrift

PATCHES=(
	"${FILESDIR}/ceph-12.2.0-use-provided-cpu-flag-values.patch"
	"${FILESDIR}/ceph-14.2.0-cflags.patch"
	"${FILESDIR}/ceph-12.2.4-boost-build-none-options.patch"
	"${FILESDIR}/ceph-16.2.2-cflags.patch"
	"${FILESDIR}/ceph-17.2.1-no-virtualenvs.patch"
	"${FILESDIR}/ceph-13.2.2-dont-install-sysvinit-script.patch"
	"${FILESDIR}/ceph-14.2.0-dpdk-cflags.patch"
	#"${FILESDIR}/ceph-16.2.0-rocksdb-cmake.patch"
	"${FILESDIR}/ceph-16.2.0-spdk-tinfo.patch"
	"${FILESDIR}/ceph-16.2.0-jaeger-system-boost.patch"
	"${FILESDIR}/ceph-16.2.0-liburing.patch"
	"${FILESDIR}/ceph-17.2.0-cyclic-deps.patch"
	"${FILESDIR}/ceph-17.2.0-pybind-boost-1.74.patch"
	"${FILESDIR}/ceph-17.2.0-findre2.patch"
	"${FILESDIR}/ceph-17.2.0-install-dbstore.patch"
	"${FILESDIR}/ceph-17.2.0-deprecated-boost.patch"
	"${FILESDIR}/ceph-17.2.0-system-opentelemetry.patch"
	"${FILESDIR}/ceph-17.2.0-fuse3.patch"
	"${FILESDIR}/ceph-17.2.0-osd_class_dir.patch"
	"${FILESDIR}/ceph-17.2.0-gcc12-header.patch"
	"${FILESDIR}/ceph-17.2.3-flags.patch"
	"${FILESDIR}/ceph-17.2.4-cyclic-deps.patch"
	# https://bugs.gentoo.org/866165
	"${FILESDIR}/ceph-17.2.5-suppress-cmake-warning.patch"
	"${FILESDIR}/ceph-17.2.5-gcc13-deux.patch"
	"${FILESDIR}/ceph-17.2.5-boost-1.81.patch"
	# https://bugs.gentoo.org/901403
	"${FILESDIR}/ceph-17.2.6-link-boost-context.patch"
)

cd "${S}"

apatch "${PATCHES[@]}"

# use system boost
find "${S}" -name '*.cmake' -or -name 'CMakeLists.txt' -print0  | xargs --null sed -r -e 's|Boost::|boost_|g' -e 's|Boost_|boost_|g' -e 's|[Bb]oost_boost|boost_system|g' -i

export Snappy_LIB=/pkg/main/app-arch.snappy.libs.1.1.10/lib$LIB_SUFFIX
export Snappy_INCLUDE_DIR=/pkg/main/app-arch.snappy.dev.1.1.10/include

cd "${T}"

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
	-DENABLE_SHARED="ON"
	-DALLOCATOR=tcmalloc
	-DWITH_SYSTEM_PMDK=YES
	-DWITH_SYSTEM_BOOST=YES
	-DWITH_SYSTEM_ROCKSDB=ON
	-DWITH_SYSTEM_ARROW=ON
	-DWITH_RDMA=OFF
	#-DEPYTHON_VERSION=3
	-DCMAKE_INSTALL_DOCDIR="/pkg/main/${PKG}.doc.${PVRF}"
	-DCMAKE_INSTALL_SYSCONFDIR=/etc
	# sphinx does not work
	-DWITH_MANPAGE=OFF
	# needed for >=glibc-2.32
	-DWITH_REENTRANT_STRSIGNAL:BOOL=ON
	-Wno-dev
)

export LD_LIBRARY_PATH="${T}/lib"
docmake "${CMAKEOPTS[@]}" || /bin/bash -i
unset LD_LIBRARY_PATH

finalize
