FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

LOGO_PREFIX = "${@bb.utils.contains("DISTRO_FEATURES", "mender-install", "mender", "Max_Jojo", d)}"
LOGO = "${LOGO_PREFIX}_${DMOSELEY_DISPLAY_RESOLUTION}.ppm"

SRC_URI_append_rpi = " \
    file://${LOGO} \
    file://enable_splash.cfg \
    ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-fastboot','file://fastboot.cfg','',d)} \
"

SERIAL_dmoseley-fastboot=""
CMDLINE_append = " ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-fastboot','quiet vt.global_cursor_default=0','console=tty1',d)} "

do_compile_prepend() {
    install -m 644 ${WORKDIR}/${LOGO} ${S}/drivers/video/logo/logo_linux_clut224.ppm
}
