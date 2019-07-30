FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_beaglebone-yocto = " \
	file://wifi-drivers.cfg \
"
SRC_URI_append_raspberrypi2 = " \
	file://wifi-drivers.cfg \
"

SRC_URI += " \
    file://logo_custom_clut224.ppm \
    file://enable_splash.cfg \
"

do_compile_prepend() {
    install -m 644 ${WORKDIR}/logo_custom_clut224.ppm ${S}/drivers/video/logo/logo_linux_clut224.ppm
}
