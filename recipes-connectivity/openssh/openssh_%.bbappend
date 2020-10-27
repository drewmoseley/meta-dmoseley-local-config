do_install_append_dmoseley-mender () {
	# Update read-only rootfs to use persistent SSH keys.
	install -d ${D}/data/ssh
	sed -i -e 's@HostKey /var/run/ssh@HostKey /data/ssh@g' ${D}${sysconfdir}/ssh/sshd_config_readonly
}
FILES_${PN} += "/data/ssh"

do_install_append_dmoseley-passwordless() {
	# Cleanup ssh
        for config_file in ${D}${sysconfdir}/ssh/sshd_config ${D}${sysconfdir}/ssh/sshd_config_readonly; do
            sed -i -e 's@^.*UsePAM.*$@UsePAM no@' \
                   -e 's@^.*PermitRootLogin.*$@PermitRootLogin prohibit-password@' \
                   -e 's@^.*PasswordAuthentication.*$@PasswordAuthentication no@' \
                   -e 's@^.*PubkeyAuthentication.*$@PubkeyAuthentication yes@' \
                      $config_file
        done
}