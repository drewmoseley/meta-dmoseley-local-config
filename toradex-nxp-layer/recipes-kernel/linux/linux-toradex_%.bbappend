FILESEXTRAPATHS_prepend_colibri-imx7 := "${THISDIR}/files:"

# Only add the Aster patch if we don't have Mender. The meta-mender-community layer
# will provide it in that case.
SRC_URI_append_colibri-imx7 = " \
    file://wifi-drivers-toradex.cfg \
    ${@bb.utils.contains("DISTRO_FEATURES", "mender-install", "", "file://0001-Fix-capacitive-touch-for-7inch-display-with-Aster-ca.patch", d)} \
"

do_configure_append_colibri-imx7() {
    cat ${WORKDIR}/wifi-drivers-toradex.cfg >> ${B}/.config
}

