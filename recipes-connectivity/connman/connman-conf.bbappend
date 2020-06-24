FILESEXTRAPATHS_prepend_dmoseley-setup := "${THISDIR}/files:"

SRC_URI_append_dmoseley-setup = " file://settings "
FILES_${PN}_append_dmoseley-setup = " /var/lib/${PN}/settings "

do_install_append_dmoseley-setup() {
	install -d -m 0755 ${D}/var/lib/${PN}
        install -m 0600 ${WORKDIR}/settings ${D}/var/lib/${PN}/
}

# Setup to be compatible for all.  The variscite layer sometimes modifies this.
COMPATIBLE_MACHINE_dmoseley-setup = ""