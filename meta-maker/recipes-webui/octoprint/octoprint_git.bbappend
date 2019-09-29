FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://99-3dprinters.rules \
"

do_install() {
    install -d ${D}${sysconfdir}/udev/rules.d
    install -m 0644 ${WORKDIR}/99-3dprinters.rules ${D}${sysconfdir}/udev/rules.d
}
