FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:dmoseley-fastboot = " \
     file://0001-Force-BOOTDELAY-to-be-0.patch \
"

SRC_URI:append = " \
    file://0001-ARM-dts-am335x-pocketbeagle-choose-tick-timer.patch \
    file://enable-ums-command.cfg \
    "

do_configure:append:beaglebone() {
    cat ${WORKDIR}/enable-ums-command.cfg >> ${B}/.configure                                       
}
