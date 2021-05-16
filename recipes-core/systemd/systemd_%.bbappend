# Configure systemd-networkd as appropriate
PACKAGECONFIG_remove = "${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-connman','networkd resolved nss-resolve','',d)}"
PACKAGECONFIG_remove = "${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-networkmanager','networkd resolved nss-resolve','',d)}"
PACKAGECONFIG_append = " ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-networkd','networkd resolved nss-resolve','',d)} "
PACKAGECONFIG_append = " journal-upload "

# Avoid issues with time being out of sync on first boot.  By default,
# systemd uses its build time as the epoch. When systemd is launched
# on a system without a real time clock, this time will be detected as
# in the future and an fsck will be done.  Setting this to 0 results
# in an epoch of January 1, 1970 which is detected as an invalid time
# and the fsck will be skipped.
PACKAGECONFIG_append = " set-time-epoch"

FILESEXTRAPATHS_prepend_dmoseley-setup := "${THISDIR}/files:"
SRC_URI_append_dmoseley-fastboot = " file://0001-systemd-Disable-getty-service.patch "

do_install_append_dmoseley-journal-upload() {
    sed -i -e 's@.*URL=*@URL=https://aruba.lab.moseleynet.net:19532@' ${D}${sysconfdir}/systemd/journal-upload.conf
}
