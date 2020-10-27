do_install_append_dmoseley-mender() {
    [ -d ${D}/var/log/nginx ] && rmdir ${D}/var/log/nginx
    install -d ${D}/data/nginx ${D}${localstatedir}/log
    ln -s /data/nginx ${D}${localstatedir}/log/nginx
}

FILES_${PN}_append_dmoseley-mender = " /data/nginx "
