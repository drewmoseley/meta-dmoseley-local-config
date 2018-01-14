do_install_append() {
	install -d ${D}/var/lib/${PN}
	install -m 0755 /work/dmoseley/local/caribbean.config ${D}/var/lib/${PN}/
        cat >> ${D}${systemd_unitdir}/system/${PN}.service <<-EOF
		
		[Service]
		ExecStartPost=/bin/sleep 5
		ExecStartPost=/usr/bin/connmanctl enable wifi
		EOF
}
