FILESEXTRAPATHS_prepend_rpi := "${THISDIR}/files:"

SRC_URI_append_rpi = " \
    file://0001-serial-pl01x-Add-support-for-devices-with-the-rate-p.patch \
    "
