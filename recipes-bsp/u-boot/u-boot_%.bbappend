FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_dmoseley-fastboot = " \
     file://0001-u-boot-Disable-serial-and-video-console-for-RpI.patch \
     file://0001-rpi-Set-CONFIG_BOTDELAY-to-0-for-fastboot.patch \
     ${@bb.utils.contains("DISTRO_FEATURES", "mender-install", \
          "file://0001-rpi-Disable-CONFIG_PREBOOT-for-fastboot-mender.patch", \
          "file://0001-rpi-Disable-CONFIG_PREBOOT-for-fastboot.patch", d)} \
"
SRC_URI_append_rpi = " \
     ${@bb.utils.contains("DISTRO_FEATURES", "mender-install", "", "file://0001-Disable-addition-of-simple-framebuffer-by-U-boot.patch", d)} \
"