FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

LOGO_PREFIX = "Max_Jojo"
LOGO = "${LOGO_PREFIX}_${DMOSELEY_DISPLAY_RESOLUTION}.ppm"

SRC_URI += " \
    file://wifi.cfg \
    file://${LOGO} \
    file://enable_splash.cfg \
    ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-fastboot','file://fastboot.cfg','',d)} \
"

SERIAL:dmoseley-fastboot=""
CMDLINE:append = " ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-fastboot','quiet vt.global_cursor_default=0','console=tty1',d)} "

do_compile:prepend() {
    install -m 644 ${WORKDIR}/${LOGO} ${S}/drivers/video/logo/logo_linux_clut224.ppm
}
