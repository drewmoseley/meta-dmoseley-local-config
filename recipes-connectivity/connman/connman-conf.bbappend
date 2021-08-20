FILESEXTRAPATHS_prepend_dmoseley-setup := "${THISDIR}/files:"

SRC_URI_append_dmoseley-setup = " file://settings "
FILES_${PN}_append_dmoseley-setup = " /var/lib/connman/settings "

do_install_append_dmoseley-setup() {
	install -d -m 0755 ${D}/var/lib/connman
        install -m 0600 ${WORKDIR}/settings ${D}/var/lib/connman/
}
