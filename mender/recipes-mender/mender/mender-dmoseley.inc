FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_append = " file://mender.conf "

MENDER_UPDATE_POLL_INTERVAL_SECONDS = "5"
MENDER_INVENTORY_POLL_INTERVAL_SECONDS = "5"
MENDER_RETRY_POLL_INTERVAL_SECONDS = "30"

DMOSELEY_MENDER_SERVER_CERT ?= "/work/dmoseley/Mender/integration/mender-production-server/production/keys-generated/certs/server.crt"

do_install_append () {
    if ${@bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-mender-prod-server', 'true', 'false', d)}; then
        # Setup my custom server.crt file
        install -m 0444 ${DMOSELEY_MENDER_SERVER_CERT} ${D}/${sysconfdir}/mender/server.crt
    fi
}