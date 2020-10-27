do_install_append_dmoseley-mender () {
	# Update read-only rootfs to use persistent SSH keys.
	install -d ${D}/data/ssh
	sed -i -e 's@HostKey /var/run/ssh@HostKey /data/ssh@g' ${D}${sysconfdir}/ssh/sshd_config_readonly
}
FILES_${PN} += "/data/ssh"
