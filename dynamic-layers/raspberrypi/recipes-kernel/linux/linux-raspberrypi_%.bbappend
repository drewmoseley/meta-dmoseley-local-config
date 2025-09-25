FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

LOGO_PREFIX = "Max_Jojo"
LOGO = "${LOGO_PREFIX}_${DMOSELEY_DISPLAY_RESOLUTION}.ppm"

SRC_URI:append = " \
    file://modules.cfg \
"
SRC_URI:append:rpi = " \
    file://${LOGO} \
    file://enable_splash.cfg \
    ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-fastboot','file://fastboot.cfg','',d)} \
"
SERIAL:dmoseley-fastboot=""
CMDLINE:prepend = " ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-fastboot','quiet vt.global_cursor_default=0','console=tty1',d)} "

do_compile:prepend() {
    install -m 644 ${WORKDIR}/${LOGO} ${S}/drivers/video/logo/logo_linux_clut224.ppm
}

RPI_KERNEL_DEVICETREE_OVERLAYS:append:dmoseley-setup = " overlays/gpio-shutdown.dtbo "
