FILESEXTRAPATHS:prepend := "${THISDIR}/files:/work/dmoseley/local:"

require /work/dmoseley/local/mender-dmoseley-certs.inc

SRC_URI:append = " \
     file://artifact-verify-key.pem \
     file://mender-inventory-yocto-buildinfo \
"

MENDER_UPDATE_POLL_INTERVAL_SECONDS = "5"
MENDER_INVENTORY_POLL_INTERVAL_SECONDS = "5"
MENDER_RETRY_POLL_INTERVAL_SECONDS = "30"

MENDER_SERVER_URL = "https://hosted.mender.io"
MENDER_TENANT_TOKEN = "${DMOSELEY_MENDER_TOKEN}"

do_compile:append () {
    cat > ${WORKDIR}/mender.conf <<-EOF
	{
	  "StateScriptTimeoutSeconds": 100
	}
	EOF
}

do_install:append () {
    # install my additional inventory tools
    install -d ${D}/${datadir}/mender/inventory
    install -t ${D}/${datadir}/mender/inventory -m 0755 \
            ${WORKDIR}/mender-inventory-*
}

PACKAGECONFIG:append = " modules "
