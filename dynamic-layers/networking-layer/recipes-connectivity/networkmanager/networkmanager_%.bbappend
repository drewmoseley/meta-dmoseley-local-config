FILESEXTRAPATHS:prepend:dmoseley-networkmanager := "${THISDIR}/files:${HOME}/SyncThing/local/:"

SRC_URI:append:dmoseley-networkmanager = " \
     ${@bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-access-point', 'file://DM_OE_AP.in', '', d)} \
"
SRC_URI:append:dmoseley-labnetworks:dmoseley-networkmanager = " \
    file://caribbean-Lab.nmconnection \
"
SRC_URI:append:dmoseley-homenetworks:dmoseley-networkmanager = " \
    file://caribbean.nmconnection \
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
        install -m 0600 ${UNPACKDIR}/DM_OE_AP.in ${D}${sysconfdir}/NetworkManager/system-connections/DM_OE_AP
        sed -i -e 's~@WIFI_IFACE@~${WIFI_IFACE}~g' ${D}${sysconfdir}/NetworkManager/system-connections/DM_OE_AP
    fi
    if ${@bb.utils.contains('PACKAGECONFIG', 'dhclient', 'true', 'false', d)}; then
        ln -s ../run/NetworkManager/resolv.conf ${D}${sysconfdir}/resolv.conf
    fi
    if ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-networkmanager','true','false',d)}; then
        # Setup my standard connection profiles
        install -d ${D}${sysconfdir}/NetworkManager/system-connections
        install -m 0600 ${UNPACKDIR}/*.nmconnection ${D}${sysconfdir}/NetworkManager/system-connections
    fi
}
