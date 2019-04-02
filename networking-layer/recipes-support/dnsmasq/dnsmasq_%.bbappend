SYSTEMD_AUTO_ENABLE = "disable"
SYSTEMD_AUTO_ENABLE_dmoseley-access-point = "enable"

do_install_append_dmoseley-access-point() {
    echo 'dhcp-range=10.0.0.10,10.0.0.200,2h' >> ${D}${sysconfdir}/dnsmasq.conf
}
