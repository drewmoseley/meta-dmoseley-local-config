SYSTEMD_AUTO_ENABLE:dmoseley-access-point = "enable"

do_install:append:dmoseley-access-point() {
    echo 'dhcp-range=10.0.0.10,10.0.0.200,2h' >> ${D}${sysconfdir}/dnsmasq.conf
}
