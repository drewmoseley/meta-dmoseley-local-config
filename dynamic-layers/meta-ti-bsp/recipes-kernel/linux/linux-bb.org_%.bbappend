FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:beaglebone = " file://wifi-drivers.cfg "