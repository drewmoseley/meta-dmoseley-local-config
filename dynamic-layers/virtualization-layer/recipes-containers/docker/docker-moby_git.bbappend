FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://daemon.json \
    "

do_install:append() {
    install -m 0744 -d ${D}${sysconfdir}/docker
    install -m 0644 ${WORKDIR}/daemon.json ${D}${sysconfdir}/docker
}
