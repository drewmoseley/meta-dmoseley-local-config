MENDER_DEMO_HOST_IP_ADDRESS = "192.168.17.41"

do_install:append:dmoseley-updater-mender() {
    # Make sure root homedir exists in persistent data partition
    install -d ${D}${sysconfdir}/tmpfiles.d
    echo "d    ${ROOT_HOME}   0700 root root - -" >> ${D}${sysconfdir}/tmpfiles.d/root-persistent-home.conf
}

do_install:append:dmoseley-updater-swupdate() {
    # Make sure root homedir exists in persistent data partition
    install -d ${D}${sysconfdir}/tmpfiles.d
    echo "d    ${ROOT_HOME}   0700 root root - -" >> ${D}${sysconfdir}/tmpfiles.d/root-persistent-home.conf
}

do_install:append:dmoseley-updater-none:rpi() {
    # Setup systemd-growfs
    sed -i -e 's@\(/dev/root.*\)defaults\(.*\)$@\1x-systemd.growfs\2@' ${D}${sysconfdir}/fstab
}