FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SYSTEMD_AUTO_ENABLE_dmoseley-connman = "enable"

SRC_URI += " file://settings "
FILES_${PN} += " /var/lib/${PN}/settings "

do_install_append() {
	install -d -m 0755 ${D}/var/lib/${PN}
        install -m 0600 ${WORKDIR}/settings ${D}/var/lib/${PN}/
}
