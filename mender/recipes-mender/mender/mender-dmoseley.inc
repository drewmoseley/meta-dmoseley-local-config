FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_append = " file://mender.conf "

MENDER_UPDATE_POLL_INTERVAL_SECONDS = "5"
MENDER_INVENTORY_POLL_INTERVAL_SECONDS = "5"
MENDER_RETRY_POLL_INTERVAL_SECONDS = "30"

DMOSELEY_MENDER_SERVER_CERT ?= ""
DMOSELEY_MENDER_SERVER_CERT_dmoseley-mender-demo-server = ""
DMOSELEY_MENDER_SERVER_CERT_dmoseley-mender-prod-server = "/work/dmoseley/Mender/integration/mender-production-server/production/keys-generated/certs/server.crt"
DMOSELEY_MENDER_SERVER_CERT_dmoseley-mender-hosted-server = ""

MENDER_DEMO_HOST_IP_ADDRESS_dmoseley-mender-demo-server = "192.168.1.36"

DMOSELEY_MENDER_TENANT_TOKEN_FILE ?= "/work/dmoseley/local/mender-tenant.txt"
def dmoseley_mender_tenant_from_file(d):
    import os.path
    fname = d.getVar('DMOSELEY_MENDER_TENANT_TOKEN_FILE', True)
    if os.path.isfile(fname):
        with open(fname, 'r') as tokFile:
            token = tokFile.readline().rstrip()
            d.setVar('MENDER_TENANT_TOKEN', token)
MENDER_TENANT_TOKEN_dmoseley-mender-hosted-server = "${@dmoseley_mender_tenant_from_file(d)}"

MENDER_SERVER_URL_dmoseley-mender-demo-server = "https://192.168.1.36"
MENDER_SERVER_URL_dmoseley-mender-prod-server = "https://192.168.1.36"
MENDER_SERVER_URL_dmoseley-mender-hosted-server = "https://hosted.mender.io"

do_install_append () {
    if [ -n "${DMOSELEY_MENDER_SERVER_CERT}" ]; then
        install -m 0444 ${DMOSELEY_MENDER_SERVER_CERT} ${D}/${sysconfdir}/mender/server.crt
    fi
}