FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

python() {
    if bb.utils.contains('DISTRO_FEATURES', 'mender-client-install', True, False, d):
        userAddVarName="USERADD_PARAM_%s" % d.getVar("PN")
        userAddVarValue=d.getVar(userAddVarName)
        userAddNewValue=userAddVarValue.replace("%s/lib/octoprint/" % d.getVar("localstatedir"), "/data/home/octoprint")
        d.setVar(userAddVarName, userAddNewValue)
}

SRC_URI += " \
    file://99-3dprinters.rules \
"
do_configure_append_mender-client-install() {
    sed -i -e "s@${sysconfdir}/octoprint@/data${sysconfdir}/octoprint@" ${WORKDIR}/octoprint.service
}

do_install_append_dmoseley-setup() {
    install -d ${D}${sysconfdir}/udev/rules.d
    install -m 0644 ${WORKDIR}/99-3dprinters.rules ${D}${sysconfdir}/udev/rules.d
}

do_install_append_mender-client-install() {
    install -d ${D}/data/${sysconfdir}/
    mv ${D}/${sysconfdir}/${PN} ${D}/data/${sysconfdir}/${PN}
    install -d ${D}/data/home/
    mv ${D}/${localstatedir}/lib/${PN} ${D}/data/home/${PN}
    chown octoprint ${D}/data/home/${PN}
}

FILES_${PN}_append_mender-client-install = " /data "
SYSTEMD_AUTO_ENABLE = "enable"
CONFFILES_${PN}_remove_mender-client-install = "${sysconfdir}/octoprint/config.yaml"
CONFFILES_${PN}_amend_mender-client-install = "/data/${sysconfdir}/octoprint/config.yaml"
