FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://disable-signing.cfg \
    file://enable-delta.cfg \
    file://swupdate-dmoseley.cfg \
    "

do_install:append() {
    install -d ${D}${sysconfdir}
    install -m 644 ${WORKDIR}/swupdate-dmoseley.cfg ${D}${sysconfdir}/swupdate.cfg
}
