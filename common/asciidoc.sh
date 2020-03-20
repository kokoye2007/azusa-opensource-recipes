# make sure we run in virtual env
if [ -d /.pkg-main-rw ]; then
	# make asciidoc work
	ln -snfT /pkg/main/app-text.asciidoc.core/etc/asciidoc /etc/asciidoc
fi
