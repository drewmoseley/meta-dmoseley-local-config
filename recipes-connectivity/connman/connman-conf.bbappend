FILESEXTRAPATHS:prepend:dmoseley-setup := "${THISDIR}/files:/work/dmoseley/local:"

SRC_URI:append:dmoseley-setup = " file://settings "
SRC_URI:append:dmoseley-homenetworks = " file://caribbean.config "
SRC_URI:append:dmoseley-labnetworks = " file://caribbean-Lab.config "
FILES:${PN}:append:dmoseley-setup = " /var/lib/connman/settings "
FILES:${PN}:append:dmoseley-homenetworks = " /var/lib/connman/caribbean.config "
FILES:${PN}:append:dmoseley-labnetworks = " /var/lib/connman/caribbean-Lab.config "

do_install:append:dmoseley-setup() {
	install -d -m 0755 ${D}/var/lib/connman
	install -m 0600 ${WORKDIR}/settings ${WORKDIR}/*.config ${D}/var/lib/connman/
}
