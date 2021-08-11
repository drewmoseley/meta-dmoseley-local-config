FILESEXTRAPATHS:prepend:dmoseley-networkmanager := "${THISDIR}/files:"

SRC_URI:append:dmoseley-networkmanager = " \
     ${@bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-access-point', 'file://DM_OE_AP.in', '', d)} \
"

SYSTEMD_AUTO_ENABLE:dmoseley-networkmanager = "enable"

PACKAGECONFIG:remove:dmoseley-networkmanager = "dhclient"
EXTRA_OECONF:append:dmoseley-networkmanager = " \
	--with-config-dhcp-default=internal \
	--with-dhclient=no \
	"

FILES:${PN}:append:dmoseley-networkmanager = " \
    ${@bb.utils.contains('PACKAGECONFIG', 'dhclient', '${sysconfdir}/resolv.conf', '', d)} \
"

PACKAGECONFIG:remove:dmoseley-networkmanager = " \
    ${@bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-access-point', '', 'dnsmasq', d)} \
"

do_install:append:dmoseley-networkmanager() {
    if ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-access-point','true','false',d)}; then
        # Default Access Point
        install -m 0600 ${WORKDIR}/DM_OE_AP.in ${D}${sysconfdir}/NetworkManager/system-connections/DM_OE_AP
        sed -i -e 's~@WIFI_IFACE@~${WIFI_IFACE}~g' ${D}${sysconfdir}/NetworkManager/system-connections/DM_OE_AP
    fi
    if ${@bb.utils.contains('PACKAGECONFIG', 'dhclient', 'true', 'false', d)}; then
        ln -s ../run/NetworkManager/resolv.conf ${D}${sysconfdir}/resolv.conf
    fi
}
