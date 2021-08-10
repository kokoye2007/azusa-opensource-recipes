# some useful stuff

multi_xmlcatalog_add() {
	local file="$1"
	shift

	local uri

	while [[ $# -gt 0 ]] ; do
		uri="$3"
		case $uri in
			file:*)
				;;
			http:*)
				;;
			https:*)
				;;
			*)
				uri="file://$uri"
				;;
		esac
		xmlcatalog --noout --add "$1" "$2" "$3" "${file}"
		shift 3
	done
}
