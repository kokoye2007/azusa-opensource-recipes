# AzusaOS package recipes

Scripts and patches used to build apkg files for various pieces of software.

We start from the ground up, with stuff requiring the less dependencies.

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

Typically a file can be adressed without specifying a version. For example it
is possible to run Python with the following line:

	/pkg/main/dev-lang.python.core/bin/python3

If however a specific version is needed, access to the latest python2 can be
done this way:

	/pkg/main/dev-lang.python.core.2/bin/python

Note that the special package azusa.symlinks offers a number of symlinks to the
different existing packages, allowing access to latest version of most packages.
