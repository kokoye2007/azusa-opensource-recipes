#!/bin/sh
source "../../common/init.sh"

get https://artifacts.elastic.co/downloads/"${PN}"/"${P}"-linux-x86_64.tar.gz
acheck

cd "${S}" || exit

rm -rf jdk || die
sed -i -e "s:logs/:${EPREFIX}/var/log/${PN}/:g" config/jvm.options || die "Unable to set Elasticsearch log location"
sed -i "s:ES_PATH_CONF=\"\$ES_HOME\"/config:ES_PATH_CONF=\"/etc/${PN}\":" bin/elasticsearch-env || die "Unable to set Elasticsearch config directory"
rmdir logs || die

# tweak elasticsearch-env to use java in /pkg/main/dev-java.openjdk.core
sed -i -e 's:JAVA=..ES_HOME.*$:JAVA="/pkg/main/dev-java.openjdk.core/bin/java":;s:bundled JDK:Azusa JDK:' bin/elasticsearch-env
#

cd "${T}" || exit
mkdir -p "${D}/pkg/main"
mv -v "${S}" "${D}/pkg/main/${PKG}.core.${PVRF}"

cd "${D}/pkg/main/${PKG}.core.${PVRF}" || exit
mkdir etc
mv -v config etc/"${PN}"

# TODO ES group
chown -vR root:root "etc"
chmod -vR +x bin modules/x-pack-ml/platform/linux-x86_64/bin

fixelf
archive
