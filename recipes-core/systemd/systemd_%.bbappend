FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

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
EXTRA_OECONF += "--with-time-epoch=0"

SRC_URI += " \
    ${@bb.utils.contains('PACKAGECONFIG','networkd','file://eth.network', '', d)} \
    ${@bb.utils.contains('PACKAGECONFIG','networkd','file://wlan.network', '', d)} \
"

FILES_${PN} += " \
    ${@bb.utils.contains('PACKAGECONFIG','networkd','${sysconfdir}/systemd/network/eth.network', '', d)} \
    ${@bb.utils.contains('PACKAGECONFIG','networkd','${sysconfdir}/systemd/network/wlan.network', '', d)} \
    ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-localntp','${sysconfdir}/systemd/timesyncd.conf', '', d)} \
"


do_install_append() {
    if ${@bb.utils.contains('PACKAGECONFIG','networkd','true','false',d)}; then
        install -d ${D}${sysconfdir}/systemd/network
        install -m 0644 ${WORKDIR}/eth.network ${D}${sysconfdir}/systemd/network
        install -m 0644 ${WORKDIR}/wlan.network ${D}${sysconfdir}/systemd/network
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
}
