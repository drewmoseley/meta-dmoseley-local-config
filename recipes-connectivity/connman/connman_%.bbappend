SYSTEMD_AUTO_ENABLE_dmoseley-connman = "enable"

do_install_append() {
	install -d ${D}/${systemd_unitdir}/system/
        cat >> ${D}${systemd_unitdir}/system/${PN}.service <<-EOF
		
		[Service]
		ExecStartPost=/bin/sleep 5
		ExecStartPost=/usr/bin/connmanctl enable wifi
		EOF
}
