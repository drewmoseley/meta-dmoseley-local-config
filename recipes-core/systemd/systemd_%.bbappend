FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# Avoid issues with time being out of sync on first boot.  By default,
# systemd uses its build time as the epoch. When systemd is launched
# on a system without a real time clock, this time will be detected as
# in the future and an fsck will be done.  Setting this to 0 results
# in an epoch of January 1, 1970 which is detected as an invalid time
# and the fsck will be skipped.
EXTRA_OECONF += "--with-time-epoch=0"

SRC_URI += " \
    file://eth.network \
    file://wlan.network \
"

FILES_${PN} += " \
    ${sysconfdir}/systemd/network/eth.network \
    ${sysconfdir}/systemd/network/wlan.network \
"


do_install_append() {
    if ${@bb.utils.contains('PACKAGECONFIG','networkd','true','false',d)}; then
        install -d ${D}${sysconfdir}/systemd/network
        install -m 0644 ${WORKDIR}/eth.network ${D}${sysconfdir}/systemd/network
        install -m 0644 ${WORKDIR}/wlan.network ${D}${sysconfdir}/systemd/network
    fi
}
