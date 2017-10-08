FILESEXTRAPATHS_prepend_rpi := "${THISDIR}/patches:"

SRC_URI_append_raspberrypi3 = " file://rpi3-0001-CONFIGS-rpi-enable-mender-requirements.patch"
SRC_URI_remove_raspberrypi3 = " file://0001-CONFIGS-rpi-enable-mender-requirements.patch"
