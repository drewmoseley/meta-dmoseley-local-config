FILESEXTRAPATHS_prepend_rpi := "${THISDIR}/files:"

SRC_URI_append_rpi = " \
    file://0001-serial-pl01x-Add-support-for-devices-with-the-rate-p.patch \
"

# This revision corresponds to the tag "v2016.05"
# We use the revision in order to avoid having to fetch it from the
# repo during parse
SRCREV_raspberrypi3 = "5a55d6c16362dd048b1774e9d45dd2a0bb37b46c"

SRC_URI_remove_raspberrypi3 = " \
    file://0001-serial-pl01x-Add-support-for-devices-with-the-rate-p.patch \
    file://0003-Include-lowlevel_init.o-for-rpi2.patch \
    "

PV_raspberrypi3 = "v2016.05+git${SRCPV}"
UBOOT_MACHINE_raspberrypi3 = "rpi_3_32b_config"
