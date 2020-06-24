FILESEXTRAPATHS_prepend_dmoseley-setup := "${THISDIR}/files:"

LOGO_PREFIX_dmoseley-setup = "${@bb.utils.contains("DISTRO_FEATURES", "mender-client-install", "mender", "Max_Jojo", d)}"
LOGO_dmoseley-setup = "${LOGO_PREFIX}_${DMOSELEY_DISPLAY_RESOLUTION}.ppm"

SRC_URI_append_dmoseley-setup = " \
    file://${LOGO} \
    file://enable_splash.cfg \
    ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-fastboot','file://fastboot.cfg','',d)} \
    ${@bb.utils.contains_any('MACHINE', 'beaglebone-yocto raspberrypi2', 'file://wifi-drivers.cfg', '', d)} \
"

SERIAL_dmoseley-fastboot=""
CMDLINE_append_dmoseley-setup = " ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-fastboot','quiet vt.global_cursor_default=0','console=tty1',d)} "

do_compile_prepend_dmoseley-setup() {
    install -m 644 ${WORKDIR}/${LOGO} ${S}/drivers/video/logo/logo_linux_clut224.ppm
}
