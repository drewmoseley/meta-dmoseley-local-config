FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_beaglebone-yocto = " \
	file://wifi-drivers.cfg \
"
SRC_URI_append_raspberrypi2 = " \
	file://wifi-drivers.cfg \
"
