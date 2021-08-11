FILESEXTRAPATHS:prepend:dmoseley-setup := "${THISDIR}/files:"

SRC_URI:append:dmoseley-setup = " file://settings "
FILES:${PN}:append:dmoseley-setup = " /var/lib/connman/settings "

do_install:append:dmoseley-setup() {
	install -d -m 0755 ${D}/var/lib/connman
        install -m 0600 ${WORKDIR}/settings ${D}/var/lib/connman/
}
