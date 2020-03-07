# AzusaOS package recipes

Scripts and patches used to build apkg files for various pieces of software.

We start from the ground up, with stuff requiring the less dependencies.

## Running apkg

	curl -s https://raw.githubusercontent.com/TrisTech/make-go/master/get.sh | /bin/sh -s apkg
	./apkg

## Requesting an update

If a given package has an update released by its developer and it has not been
ported here, please [open an issue](https://github.com/AzusaOS/azusa-opensource-recipes/issues/new)
and specify the package name, released version number and any relevant information.

The same applies for missing packages.

# Standard package naming

Currently package names mimic names found in Gentoo's portage, with some
small differences. The build system has also some similarities, including
variable names/etc.

All programs are installed in /pkg/main, using a name under the form of:

	category.name.subcategory.version

Subcategories can be one of:

* __core__: this is the main package, includes binaries, support files, etc
* __libs__: linkable libraries provided by the package
* __dev__: development files, such as static libraries, headers, cmake files, etc
* __doc__: documentation, such as man pages, etc
* __mod__: module files to be used in other contexts, such as python/etc
* __fonts__: for font files to be indexed
* __sgml__: for DTD/etc to be indexed
* __src__: source files for a given packages, not needed except for compiling (headers should be in dev)
* __misc__: other files such as reference art, generally not needed to run a package

Typically a file can be adressed without specifying a version. For example it
is possible to run Python with the following line:

	/pkg/main/dev-lang.python.core/bin/python3

If however a specific version is needed, access to the latest python2 can be
done this way:

	/pkg/main/dev-lang.python.core.2/bin/python

Note that the special package azusa.symlinks offers a number of symlinks to the
different existing packages, allowing access to latest version of most packages.

# TODO

* Improve packages instruction syntax
* Call tests prior to archive
* Run checksum and/or signature check on downloaded files
