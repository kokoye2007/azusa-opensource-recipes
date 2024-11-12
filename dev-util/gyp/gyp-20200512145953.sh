#!/bin/sh
source "../../common/init.sh"
source "${ROOTDIR}"/common/python.sh

get https://home.apache.org/~arfrever/distfiles/"${P}".tar.xz
acheck

cd "${P}" || exit

PYTHON_RESTRICT="3.10"

# sed commands from gentoo
sed -e "s/'  Linux %s' % ' '\.join(platform.linux_distribution())/'  Linux'/" -i gyptest.py || die
sed \
	-e "s/import collections/import collections.abc/" \
	-e "s/collections\.MutableSet/collections.abc.MutableSet/" \
	-i pylib/gyp/common.py || die
sed -e "s/the_dict_key is 'variables'/the_dict_key == 'variables'/" -i pylib/gyp/input.py || die
sed \
	-e "s/import collections/import collections.abc/" \
	-e "s/collections\.Iterable/collections.abc.Iterable/" \
	-i pylib/gyp/msvs_emulation.py || die
sed \
	-e "s/os\.environ\['PRESERVE'\] is not ''/os.environ['PRESERVE'] != ''/" \
	-e "s/conditions is ()/conditions == ()/" \
	-i test/lib/TestCmd.py || die

pythonsetup
archive
