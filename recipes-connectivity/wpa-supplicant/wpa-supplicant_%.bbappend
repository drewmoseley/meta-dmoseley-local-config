#
# Explicitly disable the systemd service using standard Yocto
# mechanisms for systemd-networkd.  For systemd-networkd we then
# manually create symlink in the do_install_append() below.
#
SYSTEMD_AUTO_ENABLE_dmoseley-networkd = "disable"

do_install_append () {
    if ${@bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-networkd', 'true', 'false', d)}; then
        # Enable wlan0 systemd unit file for autostart
        install -d ${D}${sysconfdir}/systemd/system//multi-user.target.wants/
        ln -s ${systemd_unitdir}/system/wpa_supplicant-nl80211@.service ${D}${sysconfdir}/systemd/system/multi-user.target.wants/wpa_supplicant-nl80211@wlan0.service
    fi
}
