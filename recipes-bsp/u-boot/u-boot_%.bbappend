FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:dmoseley-fastboot = " \
     file://0001-u-boot-Disable-serial-and-video-console-for-RpI.patch \
     file://0001-Force-BOOTDELAY-to-be-0.patch \
"

SRC_URI:append:beaglebone-yocto = " \
    file://0001-ARM-dts-am335x-pocketbeagle-choose-tick-timer.patch \
    file://enable-usb-eth-88179.cfg \
    file://enable-ums-command.cfg \
"
# SRC_URI:append:raspberrypi4 = " file://0001-rpi4-Enable-GENET-Ethernet-controller.patch"

do_configure:append:beaglebone-yocto() {
    cat ${UNPACKDIR}/enable-usb-eth-88179.cfg >> ${B}/.configure                                       
    cat ${UNPACKDIR}/enable-ums-command.cfg >> ${B}/.configure                                       
}
