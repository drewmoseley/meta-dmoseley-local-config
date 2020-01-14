FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " file://settings "
FILES_${PN} += " /var/lib/${PN}/settings "

do_install_append() {
	install -d -m 0755 ${D}/var/lib/${PN}
        install -m 0600 ${WORKDIR}/settings ${D}/var/lib/${PN}/
}

# Setup to be compatible for all.  The variscite layer sometimes modifies this.
COMPATIBLE_MACHINE = ""