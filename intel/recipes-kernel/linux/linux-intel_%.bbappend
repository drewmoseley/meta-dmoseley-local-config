FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://wifi.cfg \
    file://logo_custom_clut224.ppm \
    file://enable_splash.cfg \
    file://${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-fastboot','fastboot.cfg','enable_splash.cfg',d)} \
"

SERIAL_dmoseley-fastboot=""
CMDLINE_append_dmoseley-fastboot = " quiet "

do_compile_prepend() {
    install -m 644 ${WORKDIR}/logo_custom_clut224.ppm ${S}/drivers/video/logo/logo_linux_clut224.ppm
}
