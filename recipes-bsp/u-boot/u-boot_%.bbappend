FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_dmoseley-fastboot = " \
     file://0001-u-boot-Disable-serial-and-video-console-for-RpI.patch \
     file://0001-Force-BOOTDELAY-to-be-0.patch \
     ${@bb.utils.contains("DISTRO_FEATURES", "mender-client-install", \
          "file://0001-rpi-Disable-CONFIG_PREBOOT-for-fastboot-mender.patch", \
          "file://0001-rpi-Disable-CONFIG_PREBOOT-for-fastboot.patch", d)} \
"
