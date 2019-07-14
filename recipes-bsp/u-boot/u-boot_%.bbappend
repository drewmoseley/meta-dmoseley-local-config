FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_dmoseley-fastboot = " \
     file://0001-u-boot-Disable-serial-and-video-console-for-RpI.patch \
     file://0001-rpi-Set-CONFIG_BOTDELAY-to-0-for-fastboot.patch \
     file://0001-rpi-Disable-CONFIG_PREBOOT-for-fastboot.patch \
"
