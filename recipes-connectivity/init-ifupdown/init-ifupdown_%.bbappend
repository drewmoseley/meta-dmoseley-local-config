# Ensure that wlan0 is set to auto
#

do_install_append_dmoseley-setup () {
	echo 'auto wlan0' >> ${D}${sysconfdir}/network/interfaces
}
