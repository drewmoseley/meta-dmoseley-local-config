# Install my custom wpa_supplicant.conf-sane file.
# This is deliberately stored outside of source control only on the local filesystem.

do_install_append () {
	install -m 600 /work/dmoseley/local/wpa_supplicant.conf ${D}${sysconfdir}/wpa_supplicant.conf
}

