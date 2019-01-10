FILESEXTRAPATHS_prepend_colibri-imx7 := "${THISDIR}/files:"

SRC_URI_append_colibri-imx7 = " file://wifi-drivers-toradex.cfg"

do_configure_append_colibri-imx7() {
    echo HIDREW >> /work/dmoseley/foo.txt
    cat ${WORKDIR}/wifi-drivers-toradex.cfg >> ${B}/.config
}
