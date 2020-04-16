FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

LOGO_PREFIX = "${@bb.utils.contains("DISTRO_FEATURES", "mender-install", "mender", "Max_Jojo", d)}"
LOGO = "${LOGO_PREFIX}_${DMOSELEY_DISPLAY_RESOLUTION}.ppm"

SRC_URI += " \
    file://wifi.cfg \
    file://${LOGO} \
    file://enable_splash.cfg \
    ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-fastboot','file://fastboot.cfg','',d)} \
"

SERIAL_dmoseley-fastboot=""
CMDLINE_append_dmoseley-fastboot = " quiet "

do_compile_prepend() {
    install -m 644 ${WORKDIR}/${LOGO} ${S}/drivers/video/logo/logo_linux_clut224.ppm
}
