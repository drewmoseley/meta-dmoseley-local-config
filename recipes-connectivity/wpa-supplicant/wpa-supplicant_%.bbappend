#
# Explicitly disable the systemd service using standard Yocto
# mechanisms for systemd-networkd.  For systemd-networkd we then
# manually create symlink in the do_install_append() below.
#
SYSTEMD_AUTO_ENABLE_dmoseley-networkd = "enable"
SYSTEMD_SERVICE_${PN}_append_dmoseley-networkd = " wpa_supplicant@${WIFI_IFACE}.service "

do_install_append_dmoseley-networkd () {
    #
    # Explicitly specify both nl80211 and wext to allow for fallback on older devices
    #
    sed -i 's@\(ExecStart=.*\)@\1 -Dnl80211,wext@' ${D}/${systemd_unitdir}/system/wpa_supplicant@.service

    #
    # Enable ${WIFI_IFACE} systemd unit file for autostart
    # It seems like the SYSTEMD_SERVICE append about should handle this but
    # thus far I've not been able to get that to work.
    #
    install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants/
    ln -s ${systemd_unitdir}/system/wpa_supplicant@.service ${D}${sysconfdir}/systemd/system/multi-user.target.wants/wpa_supplicant@${WIFI_IFACE}.service
}
