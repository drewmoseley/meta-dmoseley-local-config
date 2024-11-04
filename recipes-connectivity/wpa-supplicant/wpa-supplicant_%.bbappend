FILESEXTRAPATHS:prepend:dmoseley-setup := "/work/dmoseley/local:"

# Install my custom wpa_supplicant configuration.
SRC_URI:append:dmoseley-labnetworks:dmoseley-busybox = " \
    file://wpa_supplicant-dmoseley-lab.conf \
"
SRC_URI:append:dmoseley-labnetworks:dmoseley-networkd = " \
    file://wpa_supplicant-dmoseley-lab.conf \
"
SRC_URI:append:dmoseley-homenetworks:dmoseley-networkd = " \
    file://wpa_supplicant-dmoseley-home.conf \
"

do_install:append:dmoseley-setup () {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        if ${@bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-networkd', 'true', 'false', d)}; then
            # systemd-networkd

            # Explicitly specify both nl80211 and wext to allow for fallback on older devices
            sed -i 's@\(ExecStart=.*\)@\1 -Dnl80211,wext@' ${D}/${systemd_unitdir}/system/wpa_supplicant@.service

            install -d ${D}${sysconfdir}/wpa_supplicant/
            if ${@bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-homenetworks', 'true', 'false', d)}; then
                install -D -m 600 ${WORKDIR}/wpa_supplicant-dmoseley-home.conf ${D}${sysconfdir}/wpa_supplicant/wpa_supplicant-${WIFI_IFACE}.conf
            else
                install -D -m 600 ${WORKDIR}/wpa_supplicant-dmoseley-lab.conf ${D}${sysconfdir}/wpa_supplicant/wpa_supplicant-${WIFI_IFACE}.conf
            fi
        fi
    else
        # sysvinit/busybox
        # Setup my standard wpa_supplicant.conf file in /etc
        install -D -m 600 ${WORKDIR}/wpa_supplicant-dmoseley-lab.conf ${D}${sysconfdir}/wpa_supplicant.conf
    fi
}

SYSTEMD_AUTO_ENABLE:dmoseley-networkd = "enable"
SYSTEMD_SERVICE:${PN}:append:dmoseley-networkd = " wpa_supplicant@${WIFI_IFACE}.service "
