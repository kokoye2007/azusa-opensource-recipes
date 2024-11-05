dowaf() {
	WAF_BINARY="${S}/waf"

	if [ -f "${S}/buildtools/bin/waf" ]; then
		WAF_BINARY="${S}/buildtools/bin/waf"
	fi

	# can only build from source
	cd "${S}" || exit

	CCFLAGS="${CPPFLAGS} -O2" LINKFLAGS="${LDFLAGS}" "$WAF_BINARY" --prefix="/pkg/main/${PKG}.core.${PVRF}" "$@" configure

	echo "Running waf build"
	"$WAF_BINARY" --jobs="$NPROC"
	echo "Running waf install"
	"$WAF_BINARY" --destdir="${D}" install
}
