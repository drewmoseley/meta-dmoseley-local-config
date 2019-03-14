SYSTEMD_AUTO_ENABLE_dmoseley-networkmanager = "enable"

FILES_${PN} += " \
    ${sysconfdir}/resolv.conf \
"

do_install_append() {
    ln -s ../run/NetworkManager/resolv.conf ${D}${sysconfdir}/resolv.conf
}

PACKAGECONFIG_remove = "dhclient"
EXTRA_OECONF += " \
	--with-config-dhcp-default=internal \
	--with-dhclient=no \
	"