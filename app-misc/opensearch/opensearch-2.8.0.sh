#!/bin/sh
source "../../common/init.sh"

case $ARCH in
	amd64)
		get https://artifacts.opensearch.org/releases/bundle/${PN}/${PV}/${P}-linux-x64.tar.gz
		;;
	arm64)
		get https://artifacts.opensearch.org/releases/bundle/${PN}/${PV}/${P}-linux-arm64.tar.gz
		;;
	*)
		die "no opensearch for this platform"
		;;
esac
acheck

cd "${S}"

rm -rf jdk || die
rm -f opensearch-tar-install.sh
sed -i -e "s:logs/:${EPREFIX}/var/log/${PN}/:g" config/jvm.options || die "Unable to set Opensearch log location"
sed -i "s:OPENSEARCH_PATH_CONF=\"\$OPENSEARCH_HOME\"/config:OPENSEARCH_PATH_CONF=\"/etc/${PN}\":" bin/opensearch-env || die "Unable to set Elasticsearch config directory"
rmdir logs || die
mkdir -p extensions # opensearch 2.8.0 bug https://github.com/opensearch-project/OpenSearch/issues/8563

# tweak elasticsearch-env to use java in /pkg/main/dev-java.openjdk.core
sed -i -e 's:JAVA=..OPENSEARCH_HOME.*$:JAVA="/pkg/main/dev-java.openjdk.core/bin/java":;s:bundled jdk:azusa jdk:' bin/opensearch-env
#

cd "${T}"
mkdir -p "${D}/pkg/main"
mv -v "${S}" "${D}/pkg/main/${PKG}.core.${PVRF}"

cd "${D}/pkg/main/${PKG}.core.${PVRF}"
mkdir etc
mv -v config etc/${PN}

# TODO opensearch group
chown -vR root:root "etc"

fixelf
archive
