# Ensure that wifi is set to auto
#

do_install_append_dmoseley-setup () {
	echo 'auto ${WIFI_IFACE}' >> ${D}${sysconfdir}/network/interfaces
}
