# checking all libs

	cat /etc/ld.so.conf | while read foo; do find "$foo" -name "*.so"; done | while read foo; do /lib64/ld-linux-x86-64.so.2 --list "$foo" >/dev/null; done
