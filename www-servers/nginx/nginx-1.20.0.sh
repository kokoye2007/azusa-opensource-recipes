#!/bin/sh
source "../../common/init.sh"

get https://nginx.org/download/${P}.tar.gz
acheck

cd "${P}"

callconf --prefix=/pkg/main/${PKG}.core.${PVRF} --conf-path=/etc/nginx --error-log-path=/var/log/nginx --pid-path=/var/run/nginx --lock-path=/var/run/nginx \
	--without-select_module --with-poll_module --with-threads --with-file-aio --with-http_ssl_module --with-http_v2_module --with-http_realip_module \
	--with-http_addition_module --with-http_xslt_module=dynamic --with-http_image_filter_module=dynamic --with-http_geoip_module=dynamic --with-http_sub_module \
	--with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module \
	--with-http_secure_link_module --with-http_degradation_module --with-http_slice_module --with-http_stub_status_module \
	--with-mail=dynamic --with-mail_ssl_module \
	--with-stream=dynamic --with-stream_ssl_module --with-stream_realip_module --with-stream_geoip_module=dynamic --with-stream_ssl_preread_module \
	--with-pcre --with-pcre-jit --with-libatomic

make
make install DESTDIR="${D}"

cd "${D}"

# move etc to package dir as reference
mv etc pkg/main/${PKG}.core.${PVRF}

finalize
