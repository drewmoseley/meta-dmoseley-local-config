FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_rpi_dmoseley-fastboot = " \
    file://fastboot.cfg \
"

SRC_URI_append_rpi = " \
    file://logo_custom_clut224.ppm \
    file://enable_splash.cfg \
"

SERIAL_dmoseley-fastboot=""
CMDLINE_append_dmoseley-fastboot = " quiet "

do_compile_prepend() {
    install -m 644 ${WORKDIR}/logo_custom_clut224.ppm ${S}/drivers/video/logo/logo_linux_clut224.ppm
}
