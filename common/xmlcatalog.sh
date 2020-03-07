# some useful stuff

multi_xmlcatalog_add() {
	local file="$1"
	shift

	while [[ $# -gt 0 ]] ; do
		xmlcatalog --noout --add "$1" "$2" "$3" "${file}"
		shift 3
	done
}
