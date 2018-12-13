FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_append = " \
     file://mender.conf \
     file://artifact-verify-key.pem \
     file://mender-inventory-yocto-buildinfo \
"

MENDER_UPDATE_POLL_INTERVAL_SECONDS = "5"
MENDER_INVENTORY_POLL_INTERVAL_SECONDS = "5"
MENDER_RETRY_POLL_INTERVAL_SECONDS = "30"

DMOSELEY_MENDER_SERVER_CERT ?= ""

MENDER_CERT_LOCATION_dmoseley-mender-prod-server = "${sysconfdir}/mender/server.crt"

MENDER_SERVER_URL_dmoseley-mender-prod-server = "https://tobago.home.moseleynet.net"
MENDER_SERVER_URL_dmoseley-mender-hosted-server = "https://hosted.mender.io"

do_install_append () {
    if [ -n "${DMOSELEY_MENDER_SERVER_CERT}" ]; then
        install -m 0444 ${DMOSELEY_MENDER_SERVER_CERT} ${D}/${sysconfdir}/mender/server.crt
    fi

    # install my additional inventory tools
    install -d ${D}/${datadir}/mender/inventory
    install -t ${D}/${datadir}/mender/inventory -m 0755 \
            ${WORKDIR}/mender-inventory-*

}
