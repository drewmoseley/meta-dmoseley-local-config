FILESEXTRAPATHS_prepend_rpi := "${THISDIR}/files:"

# Currently only needed on Morty.  Pyro and master already have this fix.

SRC_URI_append_rpi = " \
    file://0001-serial-pl01x-Add-support-for-devices-with-the-rate-p.patch \
    "
