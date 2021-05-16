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
