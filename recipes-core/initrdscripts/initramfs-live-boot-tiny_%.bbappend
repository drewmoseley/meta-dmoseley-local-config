FILESEXTRAPATHS_prepend_dmoseley-setup := "${THISDIR}/files:"

SRC_URI_append = " file://init-live-deadsimple-installer.sh"

do_install_append() {
        install -m 0755 ${WORKDIR}/init-live-deadsimple-installer.sh ${D}/init
}
