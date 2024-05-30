FILESEXTRAPATHS:prepend:dmoseley-setup := "${THISDIR}/files:"

inherit systemd

SRC_URI:append:dmoseley-setup = " \
    ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-networkd','file://eth.network', '', d)} \
    ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-networkd','file://en.network', '', d)} \
    ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-networkd','file://wl.network', '', d)} \
"

FILES:${PN}:append:dmoseley-setup = " \
    ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-networkd','${sysconfdir}/systemd/network/eth.network', '', d)} \
    ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-networkd','${sysconfdir}/systemd/network/en.network', '', d)} \
    ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-networkd','${sysconfdir}/systemd/network/wl.network', '', d)} \
    ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-localntp','${sysconfdir}/systemd/timesyncd.conf', '', d)} \
"


do_install:append:dmoseley-setup () {
    if ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-networkd','true','false',d)}; then
        install -d ${D}${sysconfdir}/systemd/network
        install -m 0644 ${WORKDIR}/eth.network ${D}${sysconfdir}/systemd/network
        install -m 0644 ${WORKDIR}/en.network ${D}${sysconfdir}/systemd/network
        install -m 0644 ${WORKDIR}/wl.network ${D}${sysconfdir}/systemd/network
    fi

    if ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-localntp','true','false',d)}; then
        install -d ${D}${sysconfdir}/systemd
        cat >${D}${sysconfdir}/systemd/timesyncd.conf <<EOF
[Time]
NTP=${DMOSELEY_LOCAL_NTP_ADDRESS}
FallbackNTP=time1.google.com time2.google.com time3.google.com time4.google.com
EOF
        chmod 0644 ${D}${sysconfdir}/systemd/timesyncd.conf
    fi

    if ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-persistent-logs','true','false',d)}; then
        #
        # Setup persistent systemd journaling.
        #
        for conffile in ${D}${systemd_unitdir}/journald.conf.d/00-${PN}.conf; do
            sed -i -e 's/.*ForwardToSyslog.*/ForwardToSyslog=no/' \
                   -e 's/.*RuntimeMaxUse.*/RuntimeMaxUse=64M/' $conffile
            echo "SystemMaxUse=64M" >> $conffile
            echo "Storage=persistent" >> $conffile
            echo "Compress=yes" >> $conffile
        done
    fi
}

PERSISTENT_DIR_NAME:dmoseley-updater-mender = "data"
PERSISTENT_DIR_NAME:dmoseley-updater-swupdate = "media"
PERSISTENT_DIR_NAME:dmoseley-updater-rauc = "data"

# Setup persistent logging in the persistent partition with any updater
SYSTEMD_SERVICE:${PN}:append:dmoseley-updater-any:dmoseley-persistent-logs = " var-log.mount "
SRC_URI:append:dmoseley-updater-any:dmoseley-persistent-logs = " file://var-log-${PERSISTENT_DIR_NAME}.mount "
SYSTEMD_AUTO_ENABLE = "disable"
SYSTEMD_AUTO_ENABLE:dmoseley-updater-any:dmoseley-persistent-logs = "enable"
do_install:append:dmoseley-updater-any:dmoseley-persistent-logs() {
    install -d ${D}${systemd_unitdir}/system
    install ${WORKDIR}/var-log-${PERSISTENT_DIR_NAME}.mount ${D}${systemd_unitdir}/system/var-log.mount

    # Make sure the log directory exists in persistent data partition
    install -d ${D}${sysconfdir}/tmpfiles.d
    echo "d    /${PERSISTENT_DIR_NAME}/log   0777 root root - -" >> ${D}${sysconfdir}/tmpfiles.d/logdir-persistent.conf
}
FILES:${PN}:append:dmoseley-updater-any:dmoseley-persistent-logs = " \
    /${PERSISTENT_DIR_NAME}/log ${systemd_unitdir}/system/var-log.mount \
    ${sysconfdir}/tmpfiles.d/logdir-persistent.conf \
"

SRC_URI:append:dmoseley-updater-none:dmoseley-systemd = " file://systemd-growfs-root-override.conf "
# Make sure to expand the rootfs partition.
# systemd-growfs-root will then expand the filesystem
do_install:append:dmoseley-updater-none:dmoseley-systemd() {
    install -d ${D}${sysconfdir}/systemd/system/systemd-growfs-root.service.d
    install -m 0644 ${WORKDIR}/systemd-growfs-root-override.conf ${D}${sysconfdir}/systemd/system/systemd-growfs-root.service.d/override.conf
}
FILES:${PN}:append:dmoseley-updater-none:dmoseley-systemd = " ${sysconfdir}/systemd/system/systemd-growfs-root.service.d/override.conf "
