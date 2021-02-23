FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_remove_raspberrypi4 = " file://0001-configs-rpi-enable-mender-requirements.patch file://0003-Integration-of-Mender-boot-code-into-U-Boot.patch "
SRC_URI_append_raspberrypi4 = " file://0001-configs-rpi4-enable-mender-requirements.patch file://0003-rpi4-Integration-of-Mender-boot-code-into-U-Boot.patch "
