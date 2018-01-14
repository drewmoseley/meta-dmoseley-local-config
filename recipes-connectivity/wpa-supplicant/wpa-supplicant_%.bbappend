# Install my custom wpa_supplicant configuration.
# This is deliberately stored outside of source control only on the local filesystem.

#
# Explicitly disable the systemd service using standard Yocto mechanisms
# for systemd-networkd but not for connman.  For systemd-networkd we then
# manually create sysmlink in the do_install_append() below.  This is kinda
# hackish and ideally there would be a better mechanism for this but I have
# not found it.
#
SYSTEMD_AUTO_ENABLE = "disable"
SYSTEMD_AUTO_ENABLE_dmoseley-connman = "enable"

do_install_append () {
        if ${@bb.utils.contains('DISTRO_FEATURES', 'dmoseley-connman', 'true', 'false', d)}; then
            # connman (which implies systemd)
            # Setup my standard wpa_supplicant.conf file in /etc
            install -D -m 600 /work/dmoseley/local/wpa_supplicant.conf ${D}${sysconfdir}/
        elif ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
            # systemd w/o connman (which implies networkd)
            # Setup my standard wpa_supplicant.conf file in /etc/wpa_supplicant/
            install -d ${D}${sysconfdir}/wpa_supplicant/
            install -D -m 600 /work/dmoseley/local/wpa_supplicant.conf ${D}${sysconfdir}/wpa_supplicant/wpa_supplicant-nl80211-wlan0.conf
            # Enable wlan0 systemd unit file for autostart
            install -d ${D}${sysconfdir}/systemd/system//multi-user.target.wants/
            ln -s ${systemd_unitdir}/system/wpa_supplicant-nl80211@.service ${D}${sysconfdir}/systemd/system/multi-user.target.wants/wpa_supplicant-nl80211@wlan0.service
        else
            # no connman and no systemd (which implies sysvinit)
            # Setup my standard wpa_supplicant.conf file in /etc
            install -D -m 600 /work/dmoseley/local/wpa_supplicant.conf ${D}${sysconfdir}/
        fi
}
