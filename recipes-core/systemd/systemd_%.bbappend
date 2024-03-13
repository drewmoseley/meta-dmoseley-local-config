# Configure systemd-networkd as appropriate
PACKAGECONFIG:remove = "${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-connman','networkd resolved nss-resolve','',d)}"
PACKAGECONFIG:remove = "${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-networkmanager','networkd resolved nss-resolve','',d)}"
PACKAGECONFIG:append = " ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-networkd','networkd resolved nss-resolve','',d)} "

# Avoid issues with time being out of sync on first boot.  By default,
# systemd uses its build time as the epoch. When systemd is launched
# on a system without a real time clock, this time will be detected as
# in the future and an fsck will be done.  Setting this to 0 results
# in an epoch of January 1, 1970 which is detected as an invalid time
# and the fsck will be skipped.
PACKAGECONFIG:append = " set-time-epoch"

FILESEXTRAPATHS:prepend:dmoseley-setup := "${THISDIR}/files:"
SRC_URI:append:dmoseley-fastboot = " file://0001-systemd-Disable-getty-service.patch "

# Setup persistent logging in the data partition with Mender
SYSTEMD_SERVICE:${PN}:append:dmoseley-updater-mender:dmoseley-persistent-logs = " var-log.mount "
SRC_URI:append:dmoseley-updater-mender_dmoseley-persistent-logs = " file://var-log.mount "
SYSTEMD_AUTO_ENABLE:dmoseley-updater-mender:dmoseley-persistent-logs = "enable"
do_install:append:dmoseley-updater-mender_dmoseley-persistent-logs() {
    install -d ${D}/data/
    mv ${D}${localstatedir}/log ${D}/data/log
    install -d ${D}${systemd_unitdir}/system
    install ${WORKDIR}/var-log.mount ${D}${systemd_unitdir}/system
}
FILES:${PN}:append:dmoseley-updater-mender:dmoseley-persistent-logs = " /data/log "
