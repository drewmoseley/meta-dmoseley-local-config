FILES_${PN} += " \
    ${@bb.utils.contains('PACKAGECONFIG', 'dhclient', '${sysconfdir}/resolv.conf', '', d)} \
"

do_install_append() {
    if ${@bb.utils.contains('PACKAGECONFIG', 'dhclient', 'true', 'false', d)}; then
        ln -s ../run/NetworkManager/resolv.conf ${D}${sysconfdir}/resolv.conf
    fi
}