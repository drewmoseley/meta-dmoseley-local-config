MENDER_DEMO_HOST_IP_ADDRESS = "192.168.17.41"
MENDER_DEMO_HOST_IP_ADDRESS_vexpress-qemu = ""
MENDER_DEMO_HOST_IP_ADDRESS_vexpress-qemu-flash = ""

do_install_append_dmoseley-mender() {
    install -d -m 0755 ${D}/data/etc/
    mv ${D}${sysconfdir}/hostname ${D}/data/etc/
    ln -s /data/etc/hostname ${D}/etc/hostname
}
FILES_${PN}_append_dmoseley-mender = " /data/etc/hostname "
