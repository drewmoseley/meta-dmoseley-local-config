FILESEXTRAPATHS:prepend:dmoseley-setup := "${THISDIR}/files:"

SRC_URI:append = " file://init-live-deadsimple-installer.sh"

do_install:append() {
        install -m 0755 ${WORKDIR}/init-live-deadsimple-installer.sh ${D}/init
}
