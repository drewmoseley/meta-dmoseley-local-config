FILESEXTRAPATHS:prepend:dmoseley-setup := "${THISDIR}/files:"

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

# Setup persistent logging in the data partition with Mender
SYSTEMD_SERVICE:${PN}:append:dmoseley-updater-mender:dmoseley-persistent-logs = " var-log.mount "
SRC_URI:append:dmoseley-updater-mender:dmoseley-persistent-logs = " file://var-log.mount "
SYSTEMD_AUTO_ENABLE:dmoseley-updater-mender:dmoseley-persistent-logs = "enable"
do_install:append:dmoseley-updater-mender:dmoseley-persistent-logs() {
    install -d ${D}/data/
    mv ${D}${localstatedir}/log ${D}/data/log
    install -d ${D}${systemd_unitdir}/system
    install ${WORKDIR}/var-log.mount ${D}${systemd_unitdir}/system
}
FILES:${PN}:append:dmoseley-updater-mender:dmoseley-persistent-logs = " /data/log "

# Setup persistent logging in the medie partition with swupdate
SYSTEMD_SERVICE:${PN}:append:dmoseley-updater-swupdate:dmoseley-persistent-logs = " var-log.mount "
SRC_URI:append:dmoseley-updater-swupdate:dmoseley-persistent-logs = " file://var-log-media.mount "
SYSTEMD_AUTO_ENABLE:dmoseley-updater-swupdate:dmoseley-persistent-logs = "enable"
do_install:append:dmoseley-updater-swupdate:dmoseley-persistent-logs() {
    install ${WORKDIR}/var-log-media.mount ${D}${systemd_unitdir}/system/var-log.mount

    # Make sure the log directory exists in persistent data partition
    install -d ${D}${sysconfdir}/tmpfiles.d
    echo "d    /media/log   0777 root root - -" >> ${D}${sysconfdir}/tmpfiles.d/logdir-persistent.conf
}
FILES:${PN}:append:dmoseley-updater-swupdate:dmoseley-persistent-logs = " ${sysconfdir}/tmpfiles.d/logdir-persistent.conf "
