FILESEXTRAPATHS_prepend_dmoseley-setup := "${THISDIR}/files:"

SRC_URI_append_dmoseley-setup = " \
    ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-networkd','file://eth.network', '', d)} \
    ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-networkd','file://en.network', '', d)} \
    ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-networkd','file://wl.network', '', d)} \
"

FILES_${PN}_append_dmoseley-setup = " \
    ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-networkd','${sysconfdir}/systemd/network/eth.network', '', d)} \
    ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-networkd','${sysconfdir}/systemd/network/en.network', '', d)} \
    ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-networkd','${sysconfdir}/systemd/network/wl.network', '', d)} \
    ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-localntp','${sysconfdir}/systemd/timesyncd.conf', '', d)} \
"


do_install_append_dmoseley-setup () {
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

    #
    # Setup persistent systemd journaling.
    #
    sed -i -e 's/.*ForwardToSyslog.*/ForwardToSyslog=no/' ${D}${systemd_unitdir}/journald.conf.d/00-${PN}.conf
    sed -i -e 's/.*RuntimeMaxUse.*/RuntimeMaxUse=64M/' ${D}${systemd_unitdir}/journald.conf.d/00-${PN}.conf
    sed -i -e 's/.*Storage.*/Storage=persistent/' ${D}${systemd_unitdir}/journald.conf.d/00-${PN}.conf
    sed -i -e 's/.*Compress.*/Compress=yes/' ${D}${systemd_unitdir}/journald.conf.d/00-${PN}.conf
    install -d ${D}/data/journal
    install -d ${D}${sysconfdir}/tmpfiles.d
    echo "L    /var/log/journal -    -    -     -   /data/journal" >> ${D}${sysconfdir}/tmpfiles.d/log-persist.conf
}
FILES_${PN}_append_dmoseley-setup += "/data/journal ${sysconfdir}/tmpfiles.d/log-persist.conf"
