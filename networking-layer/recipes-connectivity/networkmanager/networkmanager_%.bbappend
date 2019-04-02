FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
     ${@bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-access-point', 'file://DM_OE_AP', '', d)} \
"

SYSTEMD_AUTO_ENABLE_dmoseley-networkmanager = "enable"

PACKAGECONFIG_remove = "dhclient"
EXTRA_OECONF += " \
	--with-config-dhcp-default=internal \
	--with-dhclient=no \
	"

PACKAGECONFIG_remove = " \
    ${@bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-access-point', '', 'dnsmasq', d)} \
"

do_install_append() {
    if ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-access-point','true','false',d)}; then
        # Default Access Point
        install -m 0600 ${WORKDIR}/DM_OE_AP ${D}${sysconfdir}/NetworkManager/system-connections
    fi
}
