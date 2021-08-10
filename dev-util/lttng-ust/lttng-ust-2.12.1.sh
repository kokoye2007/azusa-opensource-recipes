#!/bin/sh
source "../../common/init.sh"

get https://lttng.org/files/${PN}/${P}.tar.bz2
acheck

cd "${T}"

importpkg dev-libs/userspace-rcu sys-process/numactl

#Features
#  sdt.h integration:                  no (use --with-sdt)
#  Java agent (JUL support):           no (use --enable-java-agent-jul)
#  Java agent (Log4j support):         no (use --enable-java-agent-log4j)
#  JNI interface (JNI):                no (use --enable-jni-interface)
#  Python agent:                       no (use --enable-python-agent)

doconf --disable-examples

make
make install DESTDIR="${D}"

finalize
