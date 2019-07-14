FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_rpi_dmoseley-fastboot = " \
    file://fastboot.cfg \
"

SERIAL_dmoseley-fastboot=""
CMDLINE_append_dmoseley-fastboot = " quiet "