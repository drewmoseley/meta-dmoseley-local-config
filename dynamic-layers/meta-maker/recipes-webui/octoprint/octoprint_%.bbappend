FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

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
do_configure:append:class-target:mender-client-install() {
    sed -i -e "s@${sysconfdir}/octoprint@/data${sysconfdir}/octoprint@" ${WORKDIR}/octoprint.service
}

do_install:append:class-target_dmoseley-setup() {
    install -d ${D}${sysconfdir}/udev/rules.d
    install -m 0644 ${WORKDIR}/99-3dprinters.rules ${D}${sysconfdir}/udev/rules.d
}

do_install:append:class-target:mender-client-install() {
    install -d ${D}/data/${sysconfdir}/
    mv ${D}/${sysconfdir}/${PN} ${D}/data/${sysconfdir}/${PN}
    install -d ${D}/data/home/
    mv ${D}/${localstatedir}/lib/${PN} ${D}/data/home/${PN}
    chown octoprint ${D}/data/home/${PN}
}

FILES:${PN}:append:mender-client-install = " /data "
SYSTEMD_AUTO_ENABLE = "enable"
CONFFILES:${PN}:remove:mender-client-install = "${sysconfdir}/octoprint/config.yaml"
CONFFILES:${PN}_amend:mender-client-install = "/data/${sysconfdir}/octoprint/config.yaml"

RDEPENDS:${PN}:append:dmoseley-setup = " python3-octoprint-themeify python3-octoprint-bedlevelvisualizer python3-octoprint-autoterminalinput python3-octoprint-octolapse "
