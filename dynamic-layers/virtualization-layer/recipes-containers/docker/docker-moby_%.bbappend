#
# Move docker runtime storage to /data with Mender
#
do_install:append_dmoseley-readonly_dmoseley-updater-mender() {
    install -d -m 0755 ${D}/data/var/lib/docker ${D}/data/${sysconfdir}/docker
    mv ${D}${sysconfdir}/docker ${D}/data/${sysconfdir}/docker
    ln -s /data${sysconfdir}/docker ${D}${sysconfdir}/docker

    install -d -m 0755 ${D}${sysconfdir}/tmpfiles.d
    echo "L     /var/lib/docker -    -    -     -   /data/var/lib/docker" >> ${D}${sysconfdir}/tmpfiles.d/docker.conf
}
FILES:${PN}:append_dmoseley-readonly_dmoseley-updater-mender = " ${sysconfdir}/tmpfiles.d/docker.conf /data/var/lib/docker /data${sysconfdir}/docker "
