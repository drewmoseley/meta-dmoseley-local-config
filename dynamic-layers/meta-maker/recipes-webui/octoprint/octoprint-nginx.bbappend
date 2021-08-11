do_install:append:dmoseley-mender() {
    [ -d ${D}/var/log/nginx ] && rmdir ${D}/var/log/nginx
    install -d ${D}/data/nginx ${D}${localstatedir}/log
    ln -s /data/nginx ${D}${localstatedir}/log/nginx
}

FILES:${PN}:append:dmoseley-mender = " /data/nginx "
