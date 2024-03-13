#!/bin/sh
source ../../common/init.sh
inherit python

export PYTHONPATH_EXTRA="/pkg/main/dev-python.Cython.mod.0.29.37.py3.12.2.linux.amd64/lib/python3.12/site-packages/"

python_do_standard_package
