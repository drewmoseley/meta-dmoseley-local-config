do_install:append:dmoseley-passwordless() {
	# Cleanup ssh
        for config_file in ${D}${sysconfdir}/ssh/sshd_config ${D}${sysconfdir}/ssh/sshd_config_readonly; do
            sed -i -e 's@^.*UsePAM.*$@UsePAM no@' \
                   -e 's@^.*PermitRootLogin.*$@PermitRootLogin prohibit-password@' \
                   -e 's@^.*PasswordAuthentication.*$@PasswordAuthentication no@' \
                   -e 's@^.*PubkeyAuthentication.*$@PubkeyAuthentication yes@' \
                      $config_file
        done
}