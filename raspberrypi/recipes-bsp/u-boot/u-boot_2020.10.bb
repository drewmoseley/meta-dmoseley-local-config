require u-boot-common-dmoseley.inc
require recipes-bsp/u-boot/u-boot.inc

DEPENDS += "bc-native dtc-native"

COMPATIBLE_MACHINE = "(raspberrypi4|raspberrypi4-64)"
