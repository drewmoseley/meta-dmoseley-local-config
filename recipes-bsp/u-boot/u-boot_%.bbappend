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
do_configure:append:beaglebone-yocto() {
    cat ${WORKDIR}/enable-usb-eth-88179.cfg >> ${B}/.configure                                       
    cat ${WORKDIR}/enable-ums-command.cfg >> ${B}/.configure                                       
}
