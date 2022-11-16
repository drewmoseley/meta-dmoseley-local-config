FILESEXTRAPATHS:prepend:dmoseley-setup := "${THISDIR}/files:"

LOGO_PREFIX:dmoseley-setup = "${@bb.utils.contains("DISTRO_FEATURES", "mender-client-install", "mender", "Max_Jojo", d)}"
LOGO:dmoseley-setup = "${LOGO_PREFIX}_${DMOSELEY_DISPLAY_RESOLUTION}.ppm"

SRC_URI:append:dmoseley-setup = " \
    file://${LOGO} \
    file://enable_splash.cfg \
    file://led.cfg \
    ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-fastboot','file://fastboot.cfg','',d)} \
    ${@bb.utils.contains_any('MACHINE', 'beaglebone-yocto raspberrypi2', 'file://wifi-drivers.cfg file://nfsd.cfg', '', d)} \
"

SRC_URI:append:beaglebone-yocto = " \
    file://usb_eth_drivers_for_rootfs.cfg \
"
SERIAL:dmoseley-fastboot=""
CMDLINE:append:dmoseley-setup = " ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-fastboot','quiet vt.global_cursor_default=0','console=tty1',d)} "

do_compile:prepend:dmoseley-setup() {
    install -m 644 ${WORKDIR}/${LOGO} ${S}/drivers/video/logo/logo_linux_clut224.ppm
}
