FILESEXTRAPATHS:prepend:dmoseley-setup := "${THISDIR}/files:"

SRC_URI:append:dmoseley-setup = " file://99-boardfarm.rules "

do_install:append:dmoseley-setup () {
	install -m 0644 ${WORKDIR}/99-boardfarm.rules ${D}${sysconfdir}/udev/rules.d/
}
