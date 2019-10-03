# Configure systemd-networkd as appropriate
PACKAGECONFIG_remove = "${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-connman','networkd resolved','',d)}"
PACKAGECONFIG_remove = "${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-networkmanager','networkd resolved','',d)}"
PACKAGECONFIG_append = " ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-networkd','networkd resolved','',d)} "

# Avoid issues with time being out of sync on first boot.  By default,
# systemd uses its build time as the epoch. When systemd is launched
# on a system without a real time clock, this time will be detected as
# in the future and an fsck will be done.  Setting this to 0 results
# in an epoch of January 1, 1970 which is detected as an invalid time
# and the fsck will be skipped.
PACKAGECONFIG_append = " time-epoch"

do_install_append() {
    if ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-fastboot','true','false',d)}; then
        rm -f ${D}${sysconfdir}/systemd/system/getty.target.wants/getty@tty1.service
    fi
}
