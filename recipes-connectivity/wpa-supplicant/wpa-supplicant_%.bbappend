# Install my custom wpa_supplicant.conf-sane file.
# This is deliberately stored outside of source control only on the local filesystem.

SYSTEMD_AUTO_ENABLE = "enable"

do_install_append () {
	install -D -m 600 /work/dmoseley/local/wpa_supplicant.conf ${D}${sysconfdir}/

        if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
            # Setup extra symlink needed by systemd WPA handling
            install -d ${D}${sysconfdir}/wpa_supplicant/
            ln -s ../wpa_supplicant.conf ${D}${sysconfdir}/wpa_supplicant/wpa_supplicant-nl80211-wlan0.conf

            # Enable wlan0 systemd unit file for autostart
            install -d ${D}${sysconfdir}/systemd/system//multi-user.target.wants/
            ln -s ${systemd_unitdir}/system/wpa_supplicant-nl80211@.service ${D}${sysconfdir}/systemd/system/multi-user.target.wants/wpa_supplicant-nl80211@wlan0.service
        fi
}

