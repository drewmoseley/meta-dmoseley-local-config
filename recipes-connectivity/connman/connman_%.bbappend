do_install_append() {
	install -d ${D}/var/lib/connman
	install -m 0755 /work/dmoseley/local/caribbean.config ${D}/var/lib/connman/
}
