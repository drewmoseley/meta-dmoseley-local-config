FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_append = " \
     file://artifact-verify-key.pem \
     file://mender-inventory-yocto-buildinfo \
"

MENDER_UPDATE_POLL_INTERVAL_SECONDS = "5"
MENDER_INVENTORY_POLL_INTERVAL_SECONDS = "5"
MENDER_RETRY_POLL_INTERVAL_SECONDS = "30"

MENDER_SERVER_URL_dmoseley-mender-prod-server = "https://tobago.home.moseleynet.net"
MENDER_SERVER_URL_dmoseley-mender-hosted-server = "https://hosted.mender.io"
MENDER_SERVER_URL_dmoseley-mender-migrate-to-hosted = ""

do_compile_append () {
    cat > ${WORKDIR}/mender.conf <<-EOF
	{
	  "StateScriptTimeoutSeconds": 100
	EOF
    if ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-mender-migrate-to-hosted','true','false',d)}; then
    cat >> ${WORKDIR}/mender.conf <<-EOF
	  , "Servers": [
	    {"ServerURL": "https://hosted.mender.io"},
	    {"ServerURL": "https://tobago.home.moseleynet.net"}
	  ]
	EOF
    fi
    cat >> ${WORKDIR}/mender.conf <<-EOF
	}
	EOF
}

do_install_append () {
    # install my additional inventory tools
    install -d ${D}/${datadir}/mender/inventory
    install -t ${D}/${datadir}/mender/inventory -m 0755 \
            ${WORKDIR}/mender-inventory-*

}

PACKAGECONFIG_append = " modules "
