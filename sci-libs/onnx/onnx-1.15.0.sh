#!/bin/sh
source "../../common/init.sh"

get https://github.com/onnx/"${PN}"/archive/refs/tags/v"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${T}" || exit

importpkg dev-libs/protobuf

# we use onnx with libcaffe2 which use an older gcc to be compatible with cuda
# it seems that if we build onnx with a more recent gcc, it later fails to link, so we use the same gcc here
# error messsage:
# /usr/bin/ld: /pkg/main/sys-libs.glibc.dev/pkg/main/sci-libs.onnx.libs.1.15.0.linux.amd64/lib64/libonnx_proto.so: undefined reference to `std::ios_base_library_init()@GLIBCXX_3.4.32'
#
# force gcc-$GCC_VERSION
GCC_VERSION=11.2
export PATH="/pkg/main/sys-devel.gcc.core.$GCC_VERSION/bin:$PATH"
rm -f /usr/bin/gcc /usr/bin/g++ /usr/bin/nvcc

docmake -DONNX_USE_PROTOBUF_SHARED_LIBS=ON -DBUILD_SHARED_LIBS=ON

finalize
